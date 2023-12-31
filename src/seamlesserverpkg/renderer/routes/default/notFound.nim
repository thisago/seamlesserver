import seamlesserverpkg/renderer/base

import seamlesserverpkg/renderer/base

proc renderHtml*(state: State): Rendered =
  ## 404 error page HTML multi-backend renderer
  result = newRendered()
  result.title = "Not Found"
  result.vnode = buildHtml(main):
    h1: text "404: Not found"

when not defined js:
  import pkg/prologue

  proc get*(ctx: Context) {.async.} =
    ## GET register page
    doAssert ctx.request.reqMethod == HttpGet
    resp ctx.ssr(renderHtml), Http404
