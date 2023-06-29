include pkg/karax/prelude

import seamlesserverpkg/renderer/base/state

proc renderFooter*(state: State): VNode =
  ## Render page footer
  buildHtml(footer):
    text "footer"
