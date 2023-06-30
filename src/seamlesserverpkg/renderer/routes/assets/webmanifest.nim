when defined js:
  {.fatal: "This module not works in Javascript backend.".}

from std/strutils import `%`
from std/os import `/`

import pkg/prologue except appName

from seamlesserverpkg/config import withConf, appName, webManifestFile, iconsDir

let path* = webManifestFile

proc get*(ctx: Context) {.async.} =
  ## GET webmanifest
  doAssert ctx.request.reqMethod == HttpGet
  withConf:
    let
      appName = appName
      iconsDir = iconsDir
      path = path
  ctx.response.headers["Content-Type"] = "application/json"
  resp readFile(path) % [
    "appName", appName,
    "iconsDir", "/" & iconsDir
  ]
