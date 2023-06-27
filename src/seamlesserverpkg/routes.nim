from renderer/routes/home import nil
from renderer/routes/user/login import nil

when not defined js:
  import pkg/prologue

  from renderer/routes/default/notFound import nil

  const
    allRoutes* = [
      pattern("/", home.render, HttpGet),
      pattern("/user/login", login.render, HttpGet),
    ]
    defaultRoutes* = {
      Http404: notFound.render
    }
else:
  const
    allRoutes* = {
      "/": home.renderHtml,
      "/user/login": login.renderHtml
    }
