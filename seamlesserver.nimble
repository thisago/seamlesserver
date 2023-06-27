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
requires "prologue" # Powerful and flexible web framework written in Nim
requires "norm" # A Nim ORM for SQLite and Postgres
requires "bcrypt" # This is a Nimrod wrapper for the bcrypt C functions.
requires "hmac" # HMAC-SHA1 and HMAC-MD5 hashing in Nim

requires "util" # Small utilities that isn't large enough to have a individual modules

# Backend and frontend
requires "karax" # Karax. Single page applications for Nim.

# Tasks

task genDocs, "Generate documentation":
  exec "rm -r docs; nim doc -d:usestd --git.commit:master --git.url:https://git.ozzuu.com/thisago/seamlesserver --project -d:ssl --out:docs ./src/seamlesserver.nim"
