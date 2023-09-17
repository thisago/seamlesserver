import pkg/karax/[karaxdsl, vdom]

import seamlesserverpkg/renderer/base/state

proc renderFooter*(state: State): VNode =
  ## Render page footer
  buildHtml(footer):
    text "footer"
