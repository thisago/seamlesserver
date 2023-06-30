when defined js:
  {.fatal: "This module not works in Javascript backend.".}

const path* = "/user/logout"

import pkg/prologue

import seamlesserverpkg/auth/utils
from seamlesserverpkg/config import sess_username
from seamlesserverpkg/userMessages import umLoggedOut
import seamlesserverpkg/renderer/base/flash

proc get*(ctx: Context) {.async.} =
  ## GET logout page
  doAssert ctx.request.reqMethod == HttpGet
  ctx.flash(umLoggedOut, Info)

  ctx.session.del sess_username
  resp redirect "/"
