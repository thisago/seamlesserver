when defined js:
  import kbase, karax, karaxdsl, vdom, compact, jstrutils # prelude
  export kbase, karax, karaxdsl, vdom, compact, jstrutils
else:
  import pkg/karax/[
    karaxdsl,
    vdom,
  ]
  export karaxdsl, vdom

import seamlesserverpkg/renderer/base/[
  header,
  footer,
  flash,
  rendered,
  state,
  bridgedData
]
export header, footer, flash, rendered, state, bridgedData

import seamlesserverpkg/renderer/base/karaxNodes/dynamicLink
export dynamicLink

when not defined js:
  from std/os import `/`
  from std/strutils import parseEnum

  import pkg/prologue except appName

  from seamlesserverpkg/config import withConf, appName, jsDir, iconsDir, jsFile,
                                        assetsDir, webManifestFile
  from seamlesserverpkg/auth/utils import isLogged

  type Render = proc(state: State): Rendered

  proc ssr*(ctx: Context; render: Render): string =
    ## Server side rendering of Karax model
    var state = ctx.newState
    for flash in ctx.getFlashedMsgsWithCategory():
      state.brData.flash(flash[1], parseEnum[FlashLevel](flash[0]))
    state.brData.flash("Hellow from server! this message will disappear after 2s", Info, 2000)
    state.brData.isLogged = ctx.isLogged
    withConf:
      let rendered = render state
      let
        appName = appName
        jsDir = jsDir
        assetsDir = assetsDir
        iconsDir = iconsDir
    let vnode = buildHtml(html):
      head:
        title: text rendered.genTitle appName
        meta(charset = "UTF-8")
        meta(name = "viewport", content = "width=device-width, initial-scale=1.0")
        meta(http-equiv = "X-UA-Compatible", content = "ie=edge")

        link(rel = "apple-touch-icon", sizes = "180x180", href = iconsDir / "apple-touch-icon.png")
        link(rel = "icon", `type` = "image/png", sizes = "32x32", href = iconsDir / "favicon-32x32.png")
        link(rel = "icon", `type` = "image/png", sizes = "16x16", href = iconsDir / "favicon-16x16.png")
        link(rel = "manifest", href = webManifestFile)
      body:
        rendered.ssrvnodes.before
        tdiv(id = "ROOT"):
          renderHeader state
          renderFlashes state.brData.flashes
          rendered.vnode
          renderFooter state
        rendered.ssrvnodes.after
        genBridgedData state.brData
        script(src = "/" & jsDir / jsFile)
    result = $vnode
