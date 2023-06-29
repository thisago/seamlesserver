from seamlesserverpkg/renderer/routes/home import nil
from seamlesserverpkg/renderer/routes/user/login import nil
from seamlesserverpkg/renderer/routes/user/register import nil
from seamlesserverpkg/renderer/routes/user/logout import nil

when not defined js:
  import pkg/prologue

  from seamlesserverpkg/renderer/routes/default/notFound import nil

  const
    allRoutes* = [
      pattern(home.path, home.get, HttpGet),
      pattern(login.path, login.get, HttpGet),
      pattern(register.path, register.get, HttpGet),
      pattern(register.path, register.post, HttpPost),
      pattern(logout.path, logout.get, HttpGet),
    ]
    defaultRoutes* = {
      Http404: notFound.get
    }
else:
  const
    allRoutes* = {
      home.path: home.renderHtml,
      register.path: register.renderHtml,
      login.path: login.renderHtml,
    }
