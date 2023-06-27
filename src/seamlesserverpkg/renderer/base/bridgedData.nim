include pkg/karax/prelude

when not defined js:
  import ../../config

type
  BridgedData* = ref object
    appName*: string

const brDataDomJsonId* = kstring "bridgedData"

using
  self: BridgedData

proc newBridgedData*: BridgedData =
  ## Creates a new BridgedData
  new result
  when not defined js:
    withConf:
      result.appName = appName

when not defined js:
  from std/json import `$`, `%*`, `%`
  
  func genBridgedData*(self): VNode =
    ## Generates the data that'll be sent to Javascript backend
    let node = $ %*self
    buildHtml(script(id = brDataDomJsonId, `type` = "application/json")):
      verbatim node
