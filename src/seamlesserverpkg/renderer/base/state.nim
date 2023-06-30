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
  mself: var State

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
  from std/dom import window, setItem, getItem
  from std/jsffi import isNull
  from std/json import `$`, `%*`, `%`, parseJson, to

  const lss_key = "lss"

  proc save*(self) =
    ## Saves the State in localStorage
    window.localStorage.setItem(lss_key, $ %*self)
  proc load*(mself) =
    ## Get the State from localStorage
    let jsonState = window.localStorage.getItem(lss_key)
    if not jsonState.isNull:
      try:
        mself = jsonState.`$`.parseJson.to State
      except:
        discard
        
