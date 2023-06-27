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
    renderHeader()
    rendered.renderErrors
    rendered.vnode
    renderFooter()

proc main =
  var s = newState()

  proc renderer(data: RouterData): VNode =
    block renderPage:
      for (path, renderHtmlPage) in allRoutes:
        if $window.location.pathname == path:
          result = render renderHtmlPage s
          break renderPage
      result = render notFound.renderHtml s
  setRenderer renderer

  document.addEventListener("pushstate") do (ev: Event):
    echo "push state"
    preventDefault ev 

when isMainModule:
  main()
