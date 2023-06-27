import pkg/prologue

from renderer/routes/default/notFound import nil
from renderer/routes/home import nil

const
  allRoutes* = @[
    pattern("/", home.render, HttpGet),
  ]
  defaultRoutes* = {
    Http404: notFound.render
  }
