from std/times import getTime, toUnix

include pkg/karax/prelude
from pkg/prologue/core/types import FlashLevel

import seamlesserverpkg/renderer/base/bridgedData

using
  flashes: BridgedData.flashes
  mflashes: var BridgedData.flashes

proc renderFlashes*(flashes): VNode =
  ## Renders all flashes into a `div`
  buildHtml(tdiv(class = "flashes")):
    for flash in flashes:
      tdiv(class = $flash.level):
        text flash.text

proc flash*(
  brData: var BridgedData;
  level: FlashLevel;
  text: string;
  duration = 1000 # ms
) =
  ## Creates new flash message in BridgedData
  brData.flashes.add FlashMessage(
    level: level,
    text: text,
    created: getTime().toUnix,
    duration: duration
  )

when defined js:
  from std/dom import setTimeout

  proc autoDeleteFlashes*(mflashes) =
    ## Automatically delete the flashes after they expire
    for i, flash in mflashes:
      discard setTimeout(proc =
        mflashes.del i
        redraw()
      , flash.duration)
