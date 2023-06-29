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
