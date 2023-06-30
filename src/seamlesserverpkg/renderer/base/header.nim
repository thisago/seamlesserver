include pkg/karax/prelude

import seamlesserverpkg/renderer/base/state
import seamlesserverpkg/renderer/base/karaxNodes/dynamicLink

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
      if state.brData.isLogged:
        li: dynamicLink(href = "/user/logout", inSpa = false):
          text "Logout"
