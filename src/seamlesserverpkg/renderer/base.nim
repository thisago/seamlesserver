include pkg/karax/prelude

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

  import seamlesserverpkg/config
  from seamlesserverpkg/auth/utils import isLogged

  type Render = proc(state: State): Rendered

  proc ssr*(ctx: Context; render: Render): string =
    ## Server side rendering of Karax model
    var state = ctx.newState
    for flash in ctx.getFlashedMsgsWithCategory():
      state.brData.flash(flash[1], parseEnum[FlashLevel](flash[0]))
    state.brData.flash("Hellow from server! this message will disappear after 2s", Info, 2000)
    state.brData.isLogged = ctx.isLogged
    echo state.brData.isLogged
    withConf:
      let rendered = render state
      let
        appName = appName
        jsDir = jsDir
    let vnode = buildHtml(html):
      head:
        title: text rendered.genTitle appName
        meta(name = "viewport", content = "width=device-width, -scale=1.0")
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
