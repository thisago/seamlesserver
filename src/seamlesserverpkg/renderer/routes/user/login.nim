include pkg/karax/prelude

import ../../base

const path* = "/user/login"

proc renderHtml*(state: State): Rendered =
  ## Renders the HTML for homepage
  new result
  result.title = "Login"
  result.vnode = buildHtml(main):
    h1: text "Login page"
    dynamicLink(href = "/"):
      text "Homepage"

when not defined js:
  import pkg/prologue
  
  proc render*(ctx: Context) {.async.} =
    ## Server side homepage renderer
    resp ssr renderHtml
