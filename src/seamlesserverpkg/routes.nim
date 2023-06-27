from renderer/routes/home import nil
from renderer/routes/user/login import nil
from renderer/routes/user/register import nil

when not defined js:
  import pkg/prologue

  from renderer/routes/default/notFound import nil

  const
    allRoutes* = [
      pattern(home.path, home.render, HttpGet),
      pattern(login.path, login.render, HttpGet),
      pattern(register.path, register.render, HttpGet),
    ]
    defaultRoutes* = {
      Http404: notFound.render
    }
else:
  const
    allRoutes* = {
      register.path: register.renderHtml,
      home.path: home.renderHtml,
      login.path: login.renderHtml,
    }
