when not defined js:
  import pkg/prologue
  import ../utils

  import std/json, std/jsonutils
  import ../../db
  import ../../db/models/user

include pkg/karax/prelude

import ../base

const path* = "/"

proc renderHtml*(state: State): Rendered =
  ## Home page HTML multi-backend renderer
  new result
  when not defined js:
    state.brData.devData = pretty toJson User.getAll()
  result.title = "Home"
  result.vnode = buildHtml(main):
    h1: text "homepage"
    pre: blockquote: text state.brData.devData

when not defined js:
  proc render*(ctx: Context) {.async.} =
    ## GET login page
    doAssert ctx.request.reqMethod == HttpGet
    if ctx.isLogged:
      resp "logged in!"
    else:
      resp ctx.ssr renderHtml
