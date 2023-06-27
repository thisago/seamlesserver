include pkg/karax/prelude

import ../base
import ../state

proc renderHtml*(state: State): VNode =
  ## Renders the HTML for homepage
  buildHtml(tdiv):
    h1: text "homepage"

when not defined js:
  import pkg/prologue

  proc render*(ctx: Context) {.async.} =
    ## Server side homepage renderer
    resp baseHtml renderHtml newState()
