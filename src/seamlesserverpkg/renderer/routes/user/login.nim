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
    result.ssrvnodes.before = buildHtml(tdiv):
      span: text "Hi, this is a static server-side rendered HTML before JS main node"
    result.ssrvnodes.after = buildHtml(tdiv):
      span: text "Hi, this is a static server-side rendered HTML after JS main node"

when not defined js:
  import pkg/prologue

  import seamlesserverpkg/auth/utils

  proc get*(ctx: Context) {.async.} =
    ## GET login page
    doAssert ctx.request.reqMethod == HttpGet
    if ctx.isLogged:
      ctx.flash(umAlreadyLoggedIn, Warning)
      resp redirect "/"
      return
    resp ctx.ssr renderHtml
