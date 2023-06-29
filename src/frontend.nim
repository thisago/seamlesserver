import std/dom

include pkg/karax/prelude

import seamlesserverpkg/renderer/base
import seamlesserverpkg/routes
import seamlesserverpkg/renderer/routes/default/notFound

proc main =
  var state = newState()

  proc render(rendered: Rendered): VNode =
    ## Renders the rendered object
    document.title = rendered.genTitle state.brData.appName
    result = buildHtml(tdiv):
      renderHeader state
      renderFlashes state.brData.flashes
      rendered.vnode
      renderFooter state

  parseBridgedData state.brData
  proc renderer(data: RouterData): VNode =
    block renderPage:
      for (path, renderHtmlPage) in allRoutes:
        if $window.location.pathname == path:
          result = render renderHtmlPage state
          break renderPage
      result = render notFound.renderHtml state
    autoDeleteFlashes state.brData.flashes

  setRenderer renderer
  
  # TODO: Mutation observer of location.pathname

when isMainModule:
  main()
