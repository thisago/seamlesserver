include pkg/karax/prelude

import seamlesserverpkg/renderer/base/[
  header,
  footer,
  flash,
  rendered,
  state
]
export header, footer, flash, rendered, state

import seamlesserverpkg/renderer/base/karaxNodes/dynamicLink
export dynamicLink

when not defined js:
  from std/os import `/`
  from std/strutils import parseEnum

  import pkg/prologue except appName

  import seamlesserverpkg/config
  import seamlesserverpkg/renderer/base/bridgedData

  type Render = proc(state: State): Rendered

  proc ssr*(ctx: Context; render: Render): string =
    ## Server side rendering of Karax model
    var state = ctx.newState
    for flash in ctx.getFlashedMsgsWithCategory():
      state.brData.flash(parseEnum[FlashLevel](flash[0]), flash[1])
    state.brData.flash(Info, "Hellow from server! this message will disappear after 2s", 2000)
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
        tdiv(id = "ROOT"):
          renderHeader state
          renderFlashes state.brData.flashes
          rendered.vnode
          renderFooter state
        genBridgedData state.brData
        script(src = "/" & jsDir / jsFile)
    result = $vnode
