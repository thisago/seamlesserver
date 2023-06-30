from seamlesserverpkg/renderer/routes/home import nil
from seamlesserverpkg/renderer/routes/user/login import nil
from seamlesserverpkg/renderer/routes/user/register import nil

when not defined js:
  import pkg/prologue

  from seamlesserverpkg/renderer/routes/user/logout import nil
  from seamlesserverpkg/renderer/routes/default/notFound import nil
  from seamlesserverpkg/renderer/routes/assets/webmanifest import nil
  from seamlesserverpkg/renderer/routes/assets/serviceWorker import nil

  var spaRoutes = [ # Don't forget to add all available SPA paths here!
    home.path,
    register.path,
    login.path
  ]

  let
    serverRoutes* = [
      pattern(home.path, home.get, HttpGet),
      pattern(login.path, login.get, HttpGet),
      pattern(login.path, login.post, HttpPost),
      pattern(register.path, register.get, HttpGet),
      pattern(register.path, register.post, HttpPost),
      pattern(logout.path, logout.get, HttpGet),

      # Static files
      pattern(webmanifest.path, webmanifest.get, HttpGet),
      pattern(serviceWorker.path, serviceWorker.genGet(spaRoutes), HttpGet),
    ]
    defaultRoutes* = {
      Http404: notFound.get
    }
else:
  const
    spaRoutes* = {
      home.path: home.renderHtml,
      register.path: register.renderHtml,
      login.path: login.renderHtml,
    }
