# Package

version       = "0.0.1"
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
requires "hmac" # HMAC-SHA1 and HMAC-MD5 hashing in Nim

requires "util" # Small utilities that isn't large enough to have a individual modules

# Backend and frontend
requires "https://github.com/thisago/karax" # Karax. Single page applications for Nim.

# Tasks

from std/os import `/`

proc minify =
  exec "uglifyjs -o js/main.js js/main.js"

task buildRelease, "Compile the server in danger mode":
  exec "nimble -d:danger --opt:speed build"
  exec "strip " & binDir / bin[0]

task buildJs, "Compile Javascript":
  exec "nim js -o:js/main.js src/frontend"
  minify()

task buildJsRelease, "Compile Javascript in danger mode":
  exec "nim js -d:danger -o:js/main.js src/frontend"
  minify()

task genDocs, "Generate documentation":
  exec "rm -r docs; nim doc -d:usestd --git.commit:master --git.url:https://git.ozzuu.com/thisago/seamlesserver --project -d:ssl --out:docs ./src/seamlesserver.nim"
