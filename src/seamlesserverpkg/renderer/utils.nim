import pkg/prologue

import seamlesserverpkg/config
import seamlesserverpkg/db
import seamlesserverpkg/db/models/user

using
  ctx: Context

proc loggedUser*(ctx): User =
  ## Gets the logged user (if exists)
  let username = ctx.session.getOrDefault(sess_username)
  if username.len > 0:
    result = User.get(username = username)

proc isLogged*(ctx): bool =
  ## Check if user is logged
  not ctx.loggedUser.isNil
