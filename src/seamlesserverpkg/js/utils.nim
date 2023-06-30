when not defined js:
  {.fatal: "This module is designed to work just in Javascript backend".}

from std/dom import window, pushState

from pkg/karax/karax import redraw

proc redirect*(url: string) =
  ## Redirects to another page using Javascript pushState
  window.history.pushState("", "", url)
  redraw()
