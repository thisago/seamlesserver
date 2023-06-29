from std/times import Duration, DateTime

include pkg/karax/prelude
from pkg/prologue/core/types import FlashLevel

when not defined js:
  import seamlesserverpkg/config

type
  FlashMessage* = object
    level*: FlashLevel
    text*: string
    created*: int64 ## unix time
    duration*: int ## ms
  BridgedData* = ref object
    ## The data sent by backend to frontend;  
    ## Needs to be able to serialize and deserialize in JSON
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

  func genBridgedData*(self): VNode =
    ## Generates the data that'll be sent to Javascript backend
    let node = $ %*self
    buildHtml(script(id = brDataDomJsonId, `type` = "application/json")):
      verbatim node
