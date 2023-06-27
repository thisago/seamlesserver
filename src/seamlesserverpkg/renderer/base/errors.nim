include pkg/karax/prelude

import ./state

proc renderErrors*(state: State): VNode =
  ## Renders all erros into a `div`
  buildHtml(tdiv(class = "errors")):
    for error in state.errors:
      tdiv(class = "error"):
        text error
