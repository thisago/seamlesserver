when not defined js:
  import pkg/prologue
  import ../utils

include pkg/karax/prelude

import ../base

const path* = "/"

proc renderHtml*(state: State): Rendered =
  ## Renders the HTML for homepage
  new result
  result.title = "Home"
  result.vnode = buildHtml(main):
    h1: text "homepage"
    when not defined js:
      p:
        text if state.ctx.isLogged: "logged user" else: "not logged"
    
when not defined js:
  import pkg/prologue

  proc render*(ctx: Context) {.async.} =
    ## Server side homepage renderer
    resp ctx.ssr renderHtml
