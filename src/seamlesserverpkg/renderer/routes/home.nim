include pkg/karax/prelude

import ../base

const path* = "/"

proc renderHtml*(state: State): Rendered =
  ## Renders the HTML for homepage
  new result
  result.title = "Home"
  result.vnode = buildHtml(main):
    h1: text "homepage"
    dynamicLink(href = "/user/login"):
      text "Login"
    br()
    dynamicLink(href = "/user/register"):
      text "Register"

when not defined js:
  import pkg/prologue

  proc render*(ctx: Context) {.async.} =
    ## Server side homepage renderer
    resp ssr renderHtml
