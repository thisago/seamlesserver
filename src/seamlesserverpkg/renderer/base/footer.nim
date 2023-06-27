include pkg/karax/prelude

proc renderFooter*: VNode =
  ## Render page footer
  buildHtml(footer):
    text "footer"
