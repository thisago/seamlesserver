include pkg/karax/prelude

import seamlesserverpkg/renderer/base

const path* = "/user/login"

proc renderHtml*(state: State): Rendered =
  ## Login page HTML multi-backend renderer
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

  import seamlesserverpkg/renderer/utils
  
  proc get*(ctx: Context) {.async.} =
    ## GET login page
    doAssert ctx.request.reqMethod == HttpGet
    let user = ctx.loggedUser
    if user.isNil:
      discard redirect "/"
    resp ctx.ssr renderHtml
