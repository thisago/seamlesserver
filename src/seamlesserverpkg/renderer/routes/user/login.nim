include pkg/karax/prelude

import ../../state
import ../../base

proc renderHtml*(state = newState()): Rendered =
  ## Renders the HTML for homepage
  new result
  result.title = "Login"
  result.vnode = buildHtml(tdiv):
    h1: text "Login page"
    dynamicLink(href = "/"):
      text "Homepage"

when not defined js:
  import pkg/prologue
  
  proc render*(ctx: Context) {.async.} =
    ## Server side homepage renderer
    resp renderHtml().inBaseHtml
