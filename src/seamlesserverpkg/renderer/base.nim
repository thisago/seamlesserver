include pkg/karax/prelude

import base/[
  header,
  footer,
  errors,
  bridgedData,
  rendered,
  state
]
export header, footer, errors, rendered, state

import base/karaxNodes/dynamicLink
export dynamicLink

when not defined js:
  from std/os import `/`

  import ../config

  type Render = proc(state: State): Rendered

  proc ssr*(render: Render): string =
    ## Server side rendering of Karax model
    let state = newState()
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
          renderHeader()
          state.renderErrors
          rendered.vnode
          renderFooter()
        state.brData.genBridgedData
        script(src = "/" & jsDir / jsFile)
    result = $vnode
