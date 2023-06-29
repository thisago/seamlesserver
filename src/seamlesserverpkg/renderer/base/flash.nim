include pkg/karax/prelude
from pkg/prologue/core/types import FlashLevel

import seamlesserverpkg/renderer/base/bridgedData

proc renderFlashes*(brData: BridgedData): VNode =
  ## Renders all flashes into a `div`
  buildHtml(tdiv(class = "flashes")):
    for flash in brData.flashes:
      tdiv(class = $flash.level):
        text flash.text

func flash*(brData: var BridgedData; level: FlashLevel; text: string) =
  ## Creates new flash message in BridgedData
  brData.flashes.add FlashMessage(level: level, text: text)
