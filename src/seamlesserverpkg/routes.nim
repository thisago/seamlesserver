from seamlesserverpkg/renderer/routes/home import nil
from seamlesserverpkg/renderer/routes/user/login import nil
from seamlesserverpkg/renderer/routes/user/register import nil

when not defined js:
  import pkg/prologue

  from seamlesserverpkg/renderer/routes/default/notFound import nil

  const
    allRoutes* = [
      pattern(home.path, home.get, HttpGet),
      pattern(login.path, login.get, HttpGet),
      pattern(register.path, register.get, HttpGet),
      pattern(register.path, register.post, HttpPost),
    ]
    defaultRoutes* = {
      Http404: notFound.get
    }
else:
  const
    allRoutes* = {
      register.path: register.renderHtml,
      home.path: home.renderHtml,
      login.path: login.renderHtml,
    }
