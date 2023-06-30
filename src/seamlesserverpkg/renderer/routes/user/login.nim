include pkg/karax/prelude

import seamlesserverpkg/renderer/base
from seamlesserverpkg/userMessages import umAlreadyLoggedIn
import seamlesserverpkg/renderer/base/flash

when defined js:
  from seamlesserverpkg/js/utils import redirect

const path* = "/user/login"

proc renderHtml*(state: State): Rendered =
  ## Login page HTML multi-backend renderer
  result = newRendered()
  when defined js:
    if state.brData.isLogged:
      state.brData.flash(umAlreadyLoggedIn, Warning)
      redirect "/"
  result.title = "Login"
  result.vnode = buildHtml(main):
    h1: text "Login page"
    form(`method` = "post"):
      input(
        name = "usernameOrEmail",
        placeholder = "Username or email",
        value = "john2",
        `type` = "text"
      )
      input(
        name = "password",
        placeholder = "Password",
        value = "johnDoe1234",
        `type` = "password"
      )
      button(`type` = "submit"): text "Submit"
  when not defined js:
    result.ssrvnodes.before = buildHtml(tdiv):
      span: text "Hi, this is a static server-side rendered HTML before JS main node"
    result.ssrvnodes.after = buildHtml(tdiv):
      span: text "Hi, this is a static server-side rendered HTML after JS main node"

when not defined js:
  import pkg/prologue

  from seamlesserverpkg/auth import isPasswordSame
  from seamlesserverpkg/auth/utils import isLogged
  from seamlesserverpkg/config import sess_username
  from seamlesserverpkg/db/models/user import User, add, get
  from seamlesserverpkg/userMessages import umAlreadyLoggedIn, umUserNotExists,
                                              umWrongPassword, umLoginSuccess

  proc get*(ctx: Context) {.async.} =
    ## GET login page
    doAssert ctx.request.reqMethod == HttpGet
    if ctx.isLogged:
      ctx.flash(umAlreadyLoggedIn, Warning)
      resp redirect "/"
      return
    resp ctx.ssr renderHtml

  proc post*(ctx: Context) {.async.} =
    ## POST login page
    doAssert ctx.request.reqMethod == HttpPost

    block loggingIn:
      if ctx.isLogged:
        ctx.flash(umAlreadyLoggedIn, Error)
        break loggingIn

      let
        userOrMail = ctx.getPostParams "usernameOrEmail"
        pass = ctx.getPostParams "password"
      
      let u = User.get(username = userOrMail, email = userOrMail)
      if u.isNil:
        ctx.flash(umUserNotExists, Error)
        break loggingIn
      echo u[]
      
      if not pass.isPasswordSame(u.password, u.salt):
        ctx.flash(umWrongPassword, Error)
        break loggingIn
    
      ctx.session[sess_username] = u.username

      ctx.flash(umLoginSuccess, Info)
      resp redirect "/"
    resp redirect path
