import std/dom

include pkg/karax/prelude

import seamlesserverpkg/renderer/base
import seamlesserverpkg/renderer/state
import seamlesserverpkg/routes
import seamlesserverpkg/renderer/routes/default/notFound

var brData: BridgedData

proc render(rendered: Rendered): VNode =
  ## Renders the rendered object
  brData = rendered.parseBridgedData
  document.title = rendered.genTitle brData.appName
  result = buildHtml(tdiv):
    rendered.renderErrors
    rendered.vnode

proc main =
  var s = newState()

  proc renderer(data: RouterData): VNode =
    buildHtml(tdiv):
      var noRoute = true
      for (path, renderHtmlPage) in allRoutes:
        if $window.location.pathname == path:
          render renderHtmlPage s
          noRoute = false
          break
      if noRoute:
        render notFound.renderHtml s
  setRenderer renderer

  document.addEventListener("pushstate") do (ev: Event):
    echo "push state"
    preventDefault ev 

when isMainModule:
  main()
