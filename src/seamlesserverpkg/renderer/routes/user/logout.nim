const path* = "/user/logout"

when not defined js:
  import pkg/prologue

  import seamlesserverpkg/auth/utils
  from seamlesserverpkg/config import sess_username

  proc get*(ctx: Context) {.async.} =
    ## GET logout page
    doAssert ctx.request.reqMethod == HttpGet

    ctx.session.del sess_username
    resp redirect "/"
