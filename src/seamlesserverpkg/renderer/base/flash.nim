from std/times import getTime, toUnix

import pkg/karax/[karaxdsl, vdom]

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
  text: string;
  level: FlashLevel;
  duration = 5000 # ms
) =
  ## Creates new flash message in BridgedData
  brData.flashes.add FlashMessage(
    level: level,
    text: text,
    createdAt: getTime().toUnix,
    duration: duration
  )

proc del*(mflashes; text: string; all = false): bool =
  ## Deletes flashes with provided text message and returns true if succeeds
  result = false
  var i = 0
  for _ in 0..<mflashes.len:
    if mflashes[i].text == text:
      mflashes.del i
      result = true
      dec i
      if not all:
        break
    inc i
when defined js:
  from pkg/karax/karax import redraw
  from std/dom import setTimeout

  proc autoDeleteFlashes*(mflashes) =
    ## Automatically delete the flashes after they expire
    for flash in mflashes.mitems:
      if not flash.deleting:
        flash.deleting = true
        discard setTimeout(proc =
          discard mflashes.del flash.text
          redraw()
        , flash.duration)
