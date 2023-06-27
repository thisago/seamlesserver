include pkg/karax/prelude

import ../../base

const path* = "/user/register"

proc renderHtml*(state: State): Rendered =
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
    resp ssr renderHtml
