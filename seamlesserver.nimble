# Package

version       = "0.0.7"
author        = "Thiago Navarro"
description   = "A web template that backend and frontend are seamless connected!"
license       = "MIT"
srcDir        = "src"
bin           = @["seamlesserver"]
binDir = "build"

# Dependencies

requires "nim >= 1.9.5"

# backend
requires "checksums" # Hash algorithms in Nim

requires "prologue" # Powerful and flexible web framework written in Nim
requires "norm" # A Nim ORM for SQLite and Postgres
# requires "hmac" # HMAC-SHA1 and HMAC-MD5 hashing in Nim

# Backend and frontend
requires "https://github.com/thisago/karax" # Single page applications for Nim. This fork makes this project possible :D

# Tasks

from std/os import `/`, commandLineParams, walkDir, pcFile
from std/strformat import fmt
from std/hashes import hash

let
  jsDir = binDir / "js"
  jsFile = "app.js"
  jsFilePath = jsDir / jsFile
  envFile = ".env"
  publicDir = "public"
  assetsDir = "assets"

  flags = fmt""
  jsFlags = fmt"-d:jsFile={jsFile} -o:{jsFilePath}"
  serverFlags = "--mm:orc --deepcopy:on --define:lto -d:ssl"
  releaseFlags = "-d:danger --opt:speed"

proc minify =
  exec fmt"uglifyjs -o {jsFilePath} {jsFilePath}"

task buildServer, "Builds the server in development mode":
  exec fmt"nimble {flags} {serverFlags} build"

task setupFiles, "Create the missing files in `build/` dir": 
  if not dirExists binDir:
    mkDir binDir
  if not fileExists binDir / envFile:
    echo fmt"Env not exists in '{binDir}' dir, copying the template."
    cpFile envFile, binDir / envFile
  if not dirExists binDir / assetsDir:
    echo fmt"Assets dir not exists in '{binDir}' dir, merging public/ to build/."
    exec fmt"cp -r {publicDir}/* {binDir}"

task runServer, "Builds the server in debug and run it!":
  setupFilesTask()
  exec fmt"clear && cd {binDir} && ./{bin[0]}"

task buildServerRelease, "Compile the server in danger mode":
  exec fmt"nimble {flags} {serverFlags} {releaseFlags} build"
  exec "strip " & binDir / bin[0]

task buildJs, "Compile Javascript":
  let bg = commandLineParams()[^1] == "background"
  exec fmt"nim js {flags} {jsFlags} src/frontend" & (
    if bg: " &" else: ""
  )
  if not bg: minify()

task buildJsRelease, "Compile Javascript in danger mode":
  exec fmt"nim js -d:danger -o:{jsFilePath} src/frontend"
  minify()

task genDocs, "Generate documentation":
  exec "rm -r docs;" &
       "nim doc -d:usestd --git.commit:master --project -d:ssl --out:docs ./src/seamlesserver.nim;" &
       "nim doc -d:usestd --git.commit:master --project -d:ssl --out:docs ./src/frontend.nim"

task compileAll, "Builds the JS in background while building server":
  exec "nimble build_js background"
  buildServerTask()

task compileAllRelease, "Builds the JS in background while building server; All in release mode":
  exec "nimble build_js_release background"
  buildServerReleaseTask()

task r, "Debug build all and run":
  setupFilesTask()
  compileAllTask()
  runServerTask()

task buildRunServer, "Debug build the server and run ir":
  setupFilesTask()
  buildServerTask()
  runServerTask()

task cleanBuild, "Deletes all files created by setup task":
  cd binDir
  for f in walkDir ".":
    if f.path[2..^1] notin [bin[0], "js"]:
      if f.kind == pcFile:
        rmFile f.path
      else:
        rmDir f.path
