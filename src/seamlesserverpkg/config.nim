import pkg/prologue

let
  env = loadPrologueEnv ".env"

  host* = env.getOrDefault("host", "localhost")
  port* = env.getOrDefault("port", 8080)
  appName* = env.getOrDefault("appName", "seamlesserver")

  settings* = newSettings(
    appName = appName,
    debug = env.getOrDefault("debug", true),
    port = Port port,
    secretKey = env.getOrDefault("secretKey", ""),
    address = host
  )

  errorLog* = env.getOrDefault("errorLog", "error.log")
  rollingLog* = env.getOrDefault("rollingLog", "rolling.log")
