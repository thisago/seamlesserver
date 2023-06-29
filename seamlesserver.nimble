# Package

version       = "0.0.3"
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

from std/os import `/`, commandLineParams
from std/strformat import fmt

let
  jsDir = binDir / "js"
  jsFile = "main.js"
  jsFilePath = jsDir / jsFile
  envFile = ".env"

  flags = fmt"-d:jsFile={jsFile}"

proc minify =
  exec fmt"uglifyjs -o {jsFilePath} {jsFilePath}"

task buildServer, "Builds the server in development mode":
  exec fmt"nimble {flags} build"

task runServer, "Builds the server in debug and run it!":
  if not fileExists binDir / envFile:
    echo fmt"Env not exists in '{binDir}' dir, using the template."
    cpFile envFile, binDir / envFile
  exec fmt"cd {binDir} && ./{bin[0]}"

task buildServerRelease, "Compile the server in danger mode":
  exec fmt"nimble {flags} -d:danger --opt:speed build"
  exec "strip " & binDir / bin[0]

task buildJs, "Compile Javascript":
  exec fmt"nim js -o:{jsFilePath} src/frontend" & (
    if commandLineParams()[^1] == "background": " &" else: ""
  )
  minify()

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
  compileAllTask()
  runServerTask()
