include pkg/karax/prelude

import ../state
import ../base

proc renderHtml*(state: State): VNode =
  ## Renders the HTML for homepage
  buildHtml(tdiv):
    h1: text "homepage"
    dynamicLink(href = "/user/login"):
      text "Login"

when not defined js:
  import pkg/prologue

  proc render*(ctx: Context) {.async.} =
    ## Server side homepage renderer
    resp baseHtml renderHtml newState()
