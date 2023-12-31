when not defined js:
  # TODO: specify the imported symbols
  import seamlesserverpkg/auth/utils
  import seamlesserverpkg/auth/utils

  # test
  from seamlesserverpkg/db import count
  from seamlesserverpkg/db/models/user import User

else:
  from std/dom import window, reload

import seamlesserverpkg/renderer/base

const path* = "/"

proc renderHtml*(state: State): Rendered =
  ## Home page HTML multi-backend renderer
  result = newRendered()
  when not defined js:
    state.brData.devData = $count User
  else:
    if state.brData.devData.len == 0:
      window.location.reload()
  result.title = "Home"
  result.vnode = buildHtml(main):
    h1: text "homepage"
    p: text "users in database: " & state.brData.devData
    h2: text (if state.brData.isLogged: "logged in" else: "not logged in")
  when not defined js:
    result.ssrvnodes.after = buildHtml(tdiv):
      h2: text "server says: " & (if state.ctx.isLogged: "logged in" else: "not logged")


when not defined js:
  import pkg/prologue except appName

  proc get*(ctx: Context) {.async.} =
    ## GET login page
    doAssert ctx.request.reqMethod == HttpGet
    resp ctx.ssr renderHtml
