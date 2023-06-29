include pkg/karax/prelude

import seamlesserverpkg/renderer/base
from seamlesserverpkg/validation/email import nil
import seamlesserverpkg/strs

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
        `type` = "text",
        value = "john2"
      )
      input(
        name = "email",
        placeholder = "Email",
        # `type` = "email",
        # pattern = email.pattern,
        value = "john2@doe.com"
      )
      input(
        name = "password",
        placeholder = "Password",
        `type` = "password",
        value = "johnDoe1234"
      )
      button(`type` = "submit"): text "Submit"

when not defined js:
  import pkg/prologue

  proc get*(ctx: Context) {.async.} =
    ## GET register page
    doAssert ctx.request.reqMethod == HttpGet
    resp ctx.ssr renderHtml

  proc post*(ctx: Context) {.async.} =
    ## POST register page
    doAssert ctx.request.reqMethod == HttpPost
    let
      username = ctx.getPostParams "username"
      mail = ctx.getPostParams "email"
      password = ctx.getPostParams "password"

    block register:
      if not email.check mail:
        ctx.flash(umInvalidEmail, Error)

      resp redirect "/"
    resp redirect path
