import ./bridgedData

type
  State* = ref object
    ## State of frontend page
    brData*: BridgedData
    errors*: seq[string]

using
  self: State

proc newState*: State =
  ## Creates new state
  new result
  result.brData = newBridgedData()

when defined js:
  from std/json import parseJson, to
  from std/dom import document, getElementById, remove

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
      self.errors.add getCurrentExceptionMsg()
