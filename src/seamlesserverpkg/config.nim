import pkg/prologue

let
  env = loadPrologueEnv ".env"

  dbHost* = env.getOrDefault("dbHost", ":memory:")
  dbUser* = env.getOrDefault("dbUser", "")
  dbPass* = env.getOrDefault("dbPass", "")

  host* = env.getOrDefault("host", "localhost")
  port* = env.getOrDefault("port", 8080)
  appName* = env.getOrDefault("appName", "seamlesserver")
  jsDir* = env.getOrDefault("jsDir", "js")

  settings* = newSettings(
    appName = appName,
    debug = env.getOrDefault("debug", true),
    port = Port port,
    secretKey = env.getOrDefault("secretKey", ""),
    address = host
  )

  errorLog* = env.getOrDefault("errorLog", "error.log")
  rollingLog* = env.getOrDefault("rollingLog", "rolling.log")

template withConf*(body: untyped) =
  ## Dirt trick to bypass gcsafe check, if I use locks, then echo doesn't works
  {.gcsafe.}:
    # withLock confLock:
    body
