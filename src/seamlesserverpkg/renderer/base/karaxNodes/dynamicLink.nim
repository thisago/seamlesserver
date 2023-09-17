when defined js:
  from std/dom import preventDefault

  import pkg/karax/[kbase, karax, karaxdsl, vdom, compact, jstrutils] # prelude

  from seamlesserverpkg/js/utils import redirect
else:
  import pkg/karax/[karaxdsl, vdom]

proc dynamicLink*(href = ""; title = ""; inSpa = true): VNode =
  ## Creates a default HTML link in backend and in frontend it just pushes the
  ## state to history, if the link is in SPA
  buildHtml(a(href = href, title = title)):
    when defined js:
      if inSpa:
        proc onclick(ev: Event; n: VNode) =
          preventDefault ev
          redirect href
