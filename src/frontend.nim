import std/dom

include pkg/karax/prelude

import seamlesserverpkg/renderer/state
import seamlesserverpkg/routes
import seamlesserverpkg/renderer/routes/default/notFound

proc main =
  var s = newState()

  proc renderer(data: RouterData): VNode =
    buildHtml(tdiv):
      var noRoute = true
      for (path, renderHtml) in allRoutes:
        if $window.location.pathname == path:
          renderHtml s
          noRoute = false
          break
      if noRoute:
        notFound.renderHtml s
  setRenderer renderer

  document.addEventListener("pushstate", proc(ev: Event) =
    echo "push state"
    preventDefault ev 
  )

when isMainModule:
  main()
