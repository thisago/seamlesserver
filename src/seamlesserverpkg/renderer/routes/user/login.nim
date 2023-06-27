include pkg/karax/prelude

import ../../base

const path* = "/user/login"

proc renderHtml*(state: State): Rendered =
  ## Renders the HTML for homepage
  new result
  result.title = "Login"
  result.vnode = buildHtml(main):
    h1: text "Login page"
    form(`method` = "post"):
      input(
        name = "username",
        placeholder = "Username",
        `type` = "text"
      )
      input(
        name = "password",
        placeholder = "Password",
        `type` = "password"
      )
      button(`type` = "submit"): text "Submit"

    

when not defined js:
  import pkg/prologue
  
  proc render*(ctx: Context) {.async.} =
    ## Server side homepage renderer
    resp ssr renderHtml
