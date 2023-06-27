include pkg/karax/prelude

import ../state
import ../base

proc renderHtml*(state = newState()): Rendered =
  ## Renders the HTML for homepage
  new result
  result.title = "Home"
  result.vnode = buildHtml(tdiv):
    h1: text "homepage"
    dynamicLink(href = "/user/login"):
      text "Login"

when not defined js:
  import pkg/prologue

  proc render*(ctx: Context) {.async.} =
    ## Server side homepage renderer
    resp renderHtml().inBaseHtml
