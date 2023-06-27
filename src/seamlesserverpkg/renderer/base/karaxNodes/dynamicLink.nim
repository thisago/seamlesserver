when defined js:
  from std/dom import preventDefault, window, pushState

include pkg/karax/prelude

proc dynamicLink*(href = ""; title = ""): VNode =
  ## Creates a default HTML link in backend and in frontend it just pushes the
  ## state to history
  buildHtml(a(href = href, title = title)):
    when defined js:
      proc onclick(ev: Event; n: VNode) =
        preventDefault ev
        window.history.pushState("", "", href)
