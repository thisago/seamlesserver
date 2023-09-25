when defined js:
  from std/dom import preventDefault

  import pkg/karax/[karax, karaxdsl, vdom]

  from seamlesserverpkg/js/utils import redirect
else:
  import pkg/karax/[karaxdsl, vdom]

proc dynamicLink*(href = ""; title = ""; useJs = true): VNode =
  ## Creates a default HTML link in backend and in frontend it just pushes the
  ## state to history, if the link is in SPA
  buildHtml(a(href = href, title = title)):
    when defined js:
      if useJs:
        proc onclick(ev: Event; n: VNode) =
          preventDefault ev
          redirect href
