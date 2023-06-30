import pkg/karax/[
  # kbase,
  vdom,
  # karax,
  karaxdsl,
]

import seamlesserverpkg/renderer/base

from seamlesserverpkg/validation/username import nil
from seamlesserverpkg/validation/email import nil
from seamlesserverpkg/validation/password import nil

from seamlesserverpkg/userMessages import umAlreadyLoggedIn
import seamlesserverpkg/renderer/base/flash

when defined js:
  from seamlesserverpkg/js/utils import redirect

const path* = "/user/register"

proc renderHtml*(state: State): Rendered {.gcsafe.} =
  ## Register page HTML multi-backend renderer
  result = newRendered()
  when defined js:
    if state.brData.isLogged:
      state.brData.flash(umAlreadyLoggedIn, Warning)
      redirect "/"
  result.title = "Register"
  result.vnode = buildHtml(main):
    h1: text "Register page"
    form(`method` = "post"):
      input(
        name = "username",
        placeholder = "Username",
        `type` = "text",
        pattern = username.pattern,
        value = "john2"
      )
      input(
        name = "email",
        placeholder = "Email",
        `type` = "email",
        pattern = email.pattern,
        value = "john2@doe.com"
      )
      input(
        name = "password",
        placeholder = "Password",
        `type` = "password",
        pattern = password.pattern,
        value = "johnDoe1234"
      )
      button(`type` = "submit"): text "Submit"
  when not defined js:
    result.ssrvnodes.before = buildHtml(tdiv):
      span: text "Hi, this is a static server-side rendered HTML"

when not defined js:
  from std/logging import error

  import pkg/prologue

  from seamlesserverpkg/auth/utils import isLogged
  from seamlesserverpkg/config import sess_username
  from seamlesserverpkg/db/models/user import User, add, get
  from seamlesserverpkg/userMessages import umInvalidEmail, umInvalidPassword,
                                            umInvalidUsername,
                                                umRegisterSuccess,
                                            umUserExists, umEmailExists,
                                            umRegisterError

  proc get*(ctx: Context) {.async.} =
    ## GET register page
    if ctx.isLogged:
      ctx.flash(umAlreadyLoggedIn, Warning)
      resp redirect "/"
      return
    resp ctx.ssr renderHtml

  proc post*(ctx: Context) {.async.} =
    ## POST register page
    doAssert ctx.request.reqMethod == HttpPost
    var code = Http400
    block registering:
      if ctx.isLogged:
        ctx.flash(umAlreadyLoggedIn, Error)
        break registering

      let
        user = ctx.getPostParams "username"
        mail = ctx.getPostParams "email"
        pass = ctx.getPostParams "password"

      if not username.check user:
        ctx.flash(umInvalidUsername, Error)
        break registering
      if not email.check mail:
        ctx.flash(umInvalidEmail, Error)
        break registering
      if not password.check pass:
        ctx.flash(umInvalidPassword, Error)
        break registering

      block checkIfExists:
        let u = User.get(username = user, email = mail)
        if not u.isNil:
          if u.username == user:
            ctx.flash(umUserExists, Error)
          elif u.email == mail:
            ctx.flash(umEmailExists, Error)
          else:
            ctx.flash(umRegisterError, Error)
          code = Http409
          break registering

      try:
        User.add(
          username = user,
          email = mail,
          password = pass
        )
      except:
        ctx.flash(umRegisterError, Error)
        error "Register error: " & getCurrentExceptionMsg()
        code = Http500
        break registering

      ctx.session[sess_username] = user
      ctx.flash(umRegisterSuccess, Info)
      resp redirect "/"
      return
    await ctx.get
    ctx.response.code = code
