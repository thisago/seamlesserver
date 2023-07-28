when defined js:
  {.fatal: "This module not works in Javascript backend.".}

import pkg/prologue except appName

from seamlesserverpkg/config import sess_username
from seamlesserverpkg/userMessages import umLoggedOut

import seamlesserverpkg/renderer/base
import seamlesserverpkg/auth/utils
import seamlesserverpkg/renderer/base/flash

const path* = "/user/logout"

proc get*(ctx: Context) {.async.} =
  ## GET logout page
  doAssert ctx.request.reqMethod == HttpGet
  ctx.flash(umLoggedOut, Info)

  ctx.session.del sess_username
  resp redirect "/"
