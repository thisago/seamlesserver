include pkg/karax/prelude
from pkg/prologue/core/types import FlashLevel

when not defined js:
  import seamlesserverpkg/config

type
  FlashMessage* = object
    level*: FlashLevel
    text*: string
  BridgedData* = ref object
    appName*: string
    flashes*: seq[FlashMessage]
    devData*: string

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
  from std/json import `$`, `%*`, `%`, JsonNode

  # proc `%`*(e: FlashLevel): JsonNode =
  #   result = JsonNode(kind: JString, str: $e)
  
  func genBridgedData*(self): VNode =
    ## Generates the data that'll be sent to Javascript backend
    let node = $ %*self
    buildHtml(script(id = brDataDomJsonId, `type` = "application/json")):
      verbatim node
