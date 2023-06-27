when defined js:
  {.fatal: "This module doesn't works in Javascript backend".}

from std/os import `/`

import ../config

include pkg/karax/prelude

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
      script(src = jsDir / "main.js")
  result = $vnode
