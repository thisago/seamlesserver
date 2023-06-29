include pkg/karax/prelude

import ../../base

const path* = "/user/register"

proc renderHtml*(state: State): Rendered {.gcsafe.} =
  ## Register page HTML multi-backend renderer
  new result
  result.title = "Register"
  result.vnode = buildHtml(main):
    h1: text "Register page"
    form(`method` = "post"):
      input(
        name = "username",
        placeholder = "Username",
        `type` = "text"
      )
      input(
        name = "email",
        placeholder = "Email",
        `type` = "email"
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
    ## GET register page
    doAssert ctx.request.reqMethod == HttpGet
    resp ctx.ssr renderHtml

  proc postRegister*(ctx: Context) {.async.} =
    ## POST register page
    doAssert ctx.request.reqMethod == HttpPost
    echo ctx.getPostParams("username")
    echo ctx.getPostParams("email")
    echo ctx.getPostParams("password")
    # redirect "/"
