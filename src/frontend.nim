include pkg/karax/prelude

import seamlesserverpkg/renderer/state
import seamlesserverpkg/routes
import seamlesserverpkg/renderer/routes/default/notFound

when isMainModule:
  var s = newState()

  proc renderer(data: RouterData): VNode =
    buildHtml(tdiv):
      var noRoute = true
      if data.hashPart.len < 2:
        data.hashPart = "#/"
      for (path, renderHtml) in allRoutes:
        if $data.hashPart == "#" & path:
          renderHtml s
          noRoute = false
          break
      if noRoute:
        notFound.renderHtml s
  setRenderer renderer
