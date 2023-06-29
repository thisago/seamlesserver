when not defined js:
  import pkg/prologue

import seamlesserverpkg/renderer/base/bridgedData

type
  State* = ref object
    ## State of frontend page
    brData*: BridgedData
    when not defined js:
      ctx*: Context

using
  self: State

when defined js:
  proc newState*: State =
    ## Creates new state
    new result
    result.brData = newBridgedData()
else:
  proc newState*(ctx: Context): State =
    ## Creates new state
    new result
    result.brData = newBridgedData()
    result.ctx = ctx
  
when defined js:
  from std/json import parseJson, to
  from std/dom import document, getElementById, remove
  
  from pkg/prologue/core/types import FlashLevel

  import seamlesserverpkg/renderer/base/flash

  proc parseBridgedData*(self) =
    ## Parses the BridgedData sent by server in a script tag
    try:
      let bridgedDataEl = document.getElementById(brDataDomJsonId)
      self.brData = bridgedDataEl.
        innerText.
        `$`.
        parseJson.
        to BridgedData
      remove bridgedDataEl
    except:
      self.brData.flash(Error, getCurrentExceptionMsg())
