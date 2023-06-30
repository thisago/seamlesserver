when not defined js:
  {.fatal: "This module is designed to work just in Javascript backend".}

import std/jsffi
from seamlesserverpkg/config import serviceWorkerFile

let navigator {.importc, nodecl.}: JsObject

try:
  navigator.serviceWorker.register serviceWorkerFile
except:
  echo getCurrentExceptionMsg()
  discard
