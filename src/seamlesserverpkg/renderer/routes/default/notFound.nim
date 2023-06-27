include pkg/karax/prelude

import ../../base

proc renderHtml*(state: State): Rendered =
  ## Renders the HTML for homepage
  new result
  result.title = "Not Found"
  result.vnode = buildHtml(tdiv):
    h1: text "404: Not found"

when not defined js:
  import pkg/prologue

  proc render*(ctx: Context) {.async.} =
    ## Server side homepage renderer
    resp ctx.ssr renderHtml
