import pkg/prologue

from seamlesserverpkg/config import sess_username
from seamlesserverpkg/db/models/user import User, get

using
  ctx: Context

proc loggedUser*(ctx): User =
  ## Gets the logged user (if exists)
  let username = ctx.session.getOrDefault sess_username
  if username.len > 0:
    result = User.get(username = username)

proc isLogged*(ctx): bool =
  ## Check if user is logged
  ctx.session.getOrDefault(sess_username).len > 0
