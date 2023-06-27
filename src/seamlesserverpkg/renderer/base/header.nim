include pkg/karax/prelude

proc renderHeader*: VNode =
  ## Render page header
  buildHtml(header):
    text "header"
