from renderer/routes/default/notFound import nil
from renderer/routes/home import nil

when not defined js:
  import pkg/prologue

  const
    allRoutes* = @[
      pattern("/", home.render, HttpGet),
    ]
    defaultRoutes* = {
      Http404: notFound.render
    }
else:
  const
    allRoutes* = {
      "/": home.renderHtml,
    }
