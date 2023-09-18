const
  serviceWorkerFile* = "sw.js"

when not defined js:
  from std/os import `/`


  const
    assetsDir* {.strdefine.} = "assets"
    jsDir* {.strdefine.} = "script"
    jsFile* {.strdefine.} = "app.js"
    webManifestFile* {.strdefine.} = "manifest.json"
    styleDir* {.strdefine.} = "style"      # in publicDir
    mainCssFile* {.strdefine.} = "app.css"
    mainSassFile* {.strdefine.} = "app.sass"
    styleIncDir* {.strdefine.} = "include" # in publicDir / styleDir

  # Session
  const
    sess_username* = "username"

  when not defined nimscript:
    import pkg/prologue

    let
      env = loadPrologueEnv ".env"

      dbHost* = env.getOrDefault("dbHost", ":memory:")
      dbUser* = env.getOrDefault("dbUser", "")
      dbPass* = env.getOrDefault("dbPass", "")

      host* = env.getOrDefault("host", "localhost")
      port* = env.getOrDefault("port", 8080)
      appName* = env.getOrDefault("appName", "Seamlesserver")

      settings* = newSettings(
        appName = appName,
        debug = env.getOrDefault("debug", true),
        port = Port port,
        secretKey = env.getOrDefault("secretKey", ""),
        address = host
      )

      errorLog* = env.getOrDefault("errorLog", "error.log")
      rollingLog* = env.getOrDefault("rollingLog", "rolling.log")

    let
      iconsDir* = assetsDir / "icons"

    template withConf*(body: untyped) =
      ## Dirt trick to bypass gcsafe check
      {.gcsafe.}:
        body
