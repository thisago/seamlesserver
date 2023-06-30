const
  serviceWorkerFile* = "sw.js"

when not defined js:
  from std/os import `/`

  import pkg/prologue

  const
    jsFile* {.strdefine.} = "app.js"
    webManifestFile* {.strdefine.} = "manifest.json"

  # Session
  const
    sess_username* = "username"

  let
    env = loadPrologueEnv ".env"

    dbHost* = env.getOrDefault("dbHost", ":memory:")
    dbUser* = env.getOrDefault("dbUser", "")
    dbPass* = env.getOrDefault("dbPass", "")

    host* = env.getOrDefault("host", "localhost")
    port* = env.getOrDefault("port", 8080)
    appName* = env.getOrDefault("appName", "seamlesserver")
    jsDir* = env.getOrDefault("jsDir", "js/")
    assetsDir* = env.getOrDefault("assetsDir", "assets/")

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
