from std/base64 import encode, decode
from std/times import Duration, DateTime

include pkg/karax/prelude
from pkg/prologue/core/types import FlashLevel
export FlashLevel

when not defined js:
  import seamlesserverpkg/config

type
  FlashMessage* = object
    level*: FlashLevel
    text*: string
    created*: int64 ## unix time
    duration*: int ## ms
    deleting*: bool
  BridgedData* = ref object
    ## The data sent by backend to frontend;  
    ## Needs to be able to serialize and deserialize in JSON
    appName*: string
    flashes*: seq[FlashMessage]
    devData*: string
    isLogged*: bool

const brDataDomJsonId* {.strdefine.} = kstring "bridgedData" # Needs to be the
                                                             # same at each
                                                             # compilation

using
  self: BridgedData
  mself: var BridgedData

proc newBridgedData*: BridgedData =
  ## Creates a new BridgedData
  new result
  when not defined js:
    withConf:
      result.appName = appName

when not defined js:
  from std/json import `$`, `%*`, `%`, JsonNode

  proc genBridgedData*(self): VNode =
    ## Generates the data that'll be sent to Javascript backend
    let node = $ %*self
    buildHtml(script(id = brDataDomJsonId, `type` = "plain/text")):
      verbatim #[encode]# node
else:
  from std/json import parseJson, to
  from std/dom import document, getElementById, remove
  from std/strutils import `%`
  
  import seamlesserverpkg/renderer/base/flash
  from seamlesserverpkg/userMessages import umErrorParseBridgedData

  proc parseBridgedData*(mself) =
    ## Parses the BridgedData sent by server in a script tag
    try:
      let bridgedDataEl = document.getElementById(brDataDomJsonId)
      mself = bridgedDataEl.
        innerText.
        `$`.
        # decode.
        parseJson.
        to BridgedData
      remove bridgedDataEl
    except:
      mself.flash(umErrorParseBridgedData % getCurrentExceptionMsg(), Error)
