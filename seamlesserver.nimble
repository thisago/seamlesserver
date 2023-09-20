# Package

version       = "0.11.0"
author        = "Thiago Navarro"
description   = "A web template that backend and frontend are seamless connected!"
license       = "MIT"
srcDir        = "src"
bin           = @["seamlesserver"]
binDir = "build"

# Dependencies

requires "nim >= 1.6.4"

# backend
requires "checksums" # Hash algorithms in Nim
requires "db_connector" # Database connection

requires "prologue" # Powerful and flexible web framework written in Nim
requires "norm" # A Nim ORM for SQLite and Postgres

# Backend and frontend
requires "karax" # Karax. Single page applications for Nim.


# Tasks

from std/os import `/`, commandLineParams, walkDir, pcFile
from std/strformat import fmt
from std/hashes import hash

from src/seamlesserverpkg/config import styleDir, mainCssFile, mainSassFile,
                                          jsDir, jsFile

let
  jsDir = binDir / jsDir
  jsFilePath = jsDir / jsFile
  envFile = ".env"
  publicDir = "public"
  assetsDir = "assets"
  cssFile = styleDir / mainCssFile
  sassFile = styleDir / mainSassFile

  jsFlags = fmt"-d:jsFile={jsFile} -o:{jsFilePath}"
  releaseFlags = "-d:danger --opt:speed"

proc existsOrCreateDir(d: string): bool =
  result = true # exists
  if not dirExists d:
    result = false
    mkDir d

task buildServer, "Builds the server in development mode":
  exec fmt"nimble build"

task buildCss, "Builds Sass and add it to `build/`":
  if existsOrCreateDir binDir / styleDir:
    rmFile binDir / cssFile
  exec fmt"sass --no-source-map {publicDir / sassFile} {publicDir / cssFile}"
  cpFile publicDir / cssFile, binDir / cssFile

task setupCssDev, "Symlink compiled CSS from public/ to build/ to allow easy development":
  rmFile binDir / cssFile
  exec fmt"ln -s $(readlink -f {publicDir / cssFile}) {binDir / cssFile}"

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
  exec fmt"nimble {releaseFlags} build"
  exec "strip " & binDir / bin[0]

task buildJs, "Compile Javascript":
  exec fmt"nim js {jsFlags} src/frontend"

task minifyJs, "Uglify js":
  exec fmt"uglifyjs -o {jsFilePath} {jsFilePath}"

task buildJsRelease, "Compile Javascript in danger mode":
  exec fmt"nim js -d:danger -o:{jsFilePath} src/frontend"
  minifyJsTask()

task genDocs, "Generate documentation":
  exec "rm -r docs;" &
       "nim doc -d:usestd --git.commit:master --project -d:ssl --out:docs ./src/seamlesserver.nim;" &
       "nim doc -d:usestd --git.commit:master --project -d:ssl --out:docs ./src/frontend.nim"

task compileAll, "Builds the JS in background while building server":
  exec "nimble build_js &"
  buildServerTask()

task compileAllRelease, "Builds the JS in background while building server; All in release mode":
  exec "nimble build_js_release &"
  buildServerReleaseTask()
  setupFilesTask()
  buildCssTask()

task r, "Debug build all and run":
  setupFilesTask()
  buildCssTask()
  setupCssDevTask()
  compileAllTask()
  runServerTask()

task buildRunServer, "Debug build the server and run ir":
  setupFilesTask()
  buildServerTask()
  runServerTask()

task cleanBuild, "Deletes all files created by setup task":
  cd binDir
  for f in walkDir ".":
    if f.path[2..^1] notin [bin[0], jsDir]:
      if f.kind == pcFile:
        rmFile f.path
      else:
        rmDir f.path

from std/os import splitFile, walkDirRec, splitPath
from std/strutils import multiReplace

task renameProject, "Since this project is a template, this task renames all files to your new name.":
  let
    currName = currentSourcePath().splitFile.name
    newName = commandLineParams()[^1]
  if newName == "renameProject":
    echo "Provide the new name"
    return
  func pkg(s: string): string {.inline.} =
    s & "pkg"
  proc renameFile(filePath: string) =
    ## Rename file and replaces all the old name imports to new one
    proc replaceCurrName(s: string): string =
      s.multiReplace({
        currName: newName,
        currName.pkg: newName.pkg
      })
    filePath.writeFile filePath.readFile.replaceCurrName
    let newPath = filePath.replaceCurrName
    if newPath != filePath:
      mvFile filePath, newPath
  mvDir srcDir / currName.pkg, srcDir / newName.pkg

  for filePath in walkDirRec ".":
    let
      f = filePath.splitFile
    let ext = if f.ext.len > 0: f.ext else: f.name
    if ext.len > 1 and ext[1..^1] in ["nim", "nimble", "nims", "md", ".gitignore", "env"]:
      renameFile filePath
