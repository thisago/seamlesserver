import pkg/karax/[karaxdsl, vdom]

import seamlesserverpkg/renderer/base/state
import seamlesserverpkg/renderer/base/karaxNodes/dynamicLink

proc renderHeader*(state: State): VNode =
  ## Render page header
  buildHtml(header):
    h2: text state.brData.appName
    ul(class = "nav"):
      li: dynamicLink(href = "/"):
        text "Home"
      if state.brData.isLogged:
        li: dynamicLink(href = "/user/logout", inSpa = false):
          text "Logout"
      else:
        li: dynamicLink(href = "/user/login"):
          text "Login"
        li: dynamicLink(href = "/user/register"):
          text "Register"
