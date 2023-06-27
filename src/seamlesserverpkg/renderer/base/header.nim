include pkg/karax/prelude

import ./state
import ./karaxNodes/dynamicLink

proc renderHeader*(state: State): VNode =
  ## Render page header
  buildHtml(header):
    h2: text state.brData.appName
    ul(class = "nav"):
      li: dynamicLink(href = "/"):
        text "Home"
      li: dynamicLink(href = "/user/login"):
        text "Login"
      li: dynamicLink(href = "/user/register"):
        text "Register"
