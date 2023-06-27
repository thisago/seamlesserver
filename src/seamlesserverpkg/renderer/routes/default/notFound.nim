include pkg/karax/prelude

import ../../state
import ../../base

proc renderHtml*(state = newState()): Rendered =
  ## Renders the HTML for homepage
  new result
  result.title = "Not Found"
  result.vnode = buildHtml(tdiv):
    h1: text "404: Not found"

when not defined js:
  import pkg/prologue

  proc render*(ctx: Context) {.async.} =
    ## Server side homepage renderer
    resp renderHtml().inBaseHtml
