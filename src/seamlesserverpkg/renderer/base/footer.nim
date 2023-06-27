include pkg/karax/prelude

import ./state

proc renderFooter*(state: State): VNode =
  ## Render page footer
  buildHtml(footer):
    text "footer"
