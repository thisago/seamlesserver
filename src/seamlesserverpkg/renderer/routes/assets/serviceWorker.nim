when defined js:
  {.fatal: "This module not works in Javascript backend.".}

from std/strutils import `%`, join
from std/os import `/`

import pkg/prologue

from seamlesserverpkg/config import withConf, serviceWorkerFile, jsDir, jsFile,
                                      styleDir, mainCssFile

let path* = serviceWorkerFile

proc genGet*(spaRoutes: openArray[string]): HandlerAsync =
  ## Generates a GET service worker JS file handler
  let path = path
  var files = @[
    "/" & jsDir / jsFile,
    "/" & styleDir / mainCssFile
  ]
  for route in spaRoutes:
    files.add route
  result = proc(ctx: Context) {.async.} =
    doAssert ctx.request.reqMethod == HttpGet
    ctx.response.headers["Content-Type"] = "application/javascript"
    resp path.readFile % [
      "filesToCache", "\"" & files.join("\",\"") & "\""
    ]
