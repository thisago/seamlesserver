when defined js:
  import std/dom

include pkg/karax/prelude

proc dynamicLink*(href = ""; title = ""): VNode =
  ## Creates a default HTML link in backend and in frontend it just pushes the
  ## state to history
  buildHtml(a(href = href, title = title)):
    when defined js:
      proc onclick(ev: Event; n: VNode) =
        preventDefault ev
        window.history.pushState("", "", href)
        echo "pushed"

when not defined js:
  from std/os import `/`

  import ../config

  proc baseHtml*(bodyNode: VNode): string =
    withConf:
      let
        appName = appName
        jsDir = jsDir
    let vnode = buildHtml(html):
      head:
        title: text appName
        meta(name="viewport", content="width=device-width, initial-scale=1.0")
      body:
        tdiv(id = "ROOT"):
          bodyNode
        script(src = "/" & jsDir / "main.js")
    result = $vnode
