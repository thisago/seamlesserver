import std/logging

import pkg/prologue
import pkg/prologue/middlewares/utils
import pkg/prologue/middlewares/staticFile
import pkg/prologue/middlewares/signedCookieSession

import seamlesserverpkg/[
  config,
  routes,
  db
]
import seamlesserverpkg/db/setup

proc main =
  inDb:
    dbConn = open(dbHost, dbUser, dbPass, "")
    setup dbConn

  proc setLoggingLevel(settings: Settings; errorLog, rollingLog: string): auto =
    result = proc =
      addHandler newFileLogger(errorLog, levelThreshold = lvlError)
      addHandler newRollingFileLogger rollingLog
      addHandler newConsoleLogger()
      if settings.debug:
        logging.setLogFilter(lvlDebug)
      else:
        logging.setLogFilter(lvlInfo)

  var app = newApp(
    settings = settings,
    startup = @[
      initEvent(settings.setLoggingLevel(errorLog, rollingLog))
    ]
  )

  proc sessionMw: HandlerAsync =
    ## This is a tricky way to prevent error showing to client if session
    ## was corrupted
    let mw = sessionMiddleware(settings)
    result = proc(ctx: Context) {.async.} =
      try:
        await mw ctx
      except:
        logging.info "Corrupted session"
      finally:
        await switch(ctx)

  app.use @[
    debugRequestMiddleware(),
    sessionMw(),
    staticFileMiddleware jsDir
  ]

  app.addRoute allRoutes
  for (code, renderer) in defaultRoutes:
    app.registerErrorHandler(code, renderer)

  app.run()

when isMainModule:
  main()
else:
  {.fatal: "This app cannot be imported.".}
