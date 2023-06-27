include pkg/karax/prelude

import ../../state
import ../../base

proc renderHtml*(state = newState()): Rendered =
  ## Renders the HTML for homepage
  new result
  result.title = "Register"
  result.vnode = buildHtml(main):
    h1: text "Register page"
    dynamicLink(href = "/"):
      text "Homepage"

when not defined js:
  import pkg/prologue
  
  proc render*(ctx: Context) {.async.} =
    ## Server side homepage renderer
    resp renderHtml().inBaseHtml
