from std/strformat import fmt

when defined js:
  import std/dom

include pkg/karax/prelude

type
  Rendered* = ref object
    vnode*: VNode
    title*: string
    errors*: seq[string]
  BridgedData* = ref object
    appName*: string

const brDataDomJsonId = kstring "bridgedData"

using
  rendered: Rendered

proc addError*(rendered; msg: string) =
  ## Add new error
  rendered.errors.add msg

proc renderErrors*(rendered): VNode =
  ## Renders all erros into a `div`
  buildHtml(tdiv(class = "errors")):
    for error in rendered.errors:
      tdiv(class = "error"):
        text error

proc dynamicLink*(href = ""; title = ""): VNode =
  ## Creates a default HTML link in backend and in frontend it just pushes the
  ## state to history
  buildHtml(a(href = href, title = title)):
    when defined js:
      proc onclick(ev: Event; n: VNode) =
        preventDefault ev
        window.history.pushState("", "", href)

func genTitle*(rendered; appName: string): string =
  ## Gets the rendered page title
  fmt"{rendered.title} - {appName}"

when not defined js:
  from std/os import `/`
  from std/json import `$`, `%*`, `%`

  import ../config

  func genBridgedData(appName: string): VNode =
    ## Generates the data that'll be sent to Javascript backend
    let node = $ %*{
      "appName": appName
    }
    buildHtml(script(id = brDataDomJsonId, `type` = "application/json")):
      verbatim node
  proc inbaseHtml*(rendered): string =
    ## Creates the full HTML page with rendered page
    withConf:
      let
        appName = appName
        jsDir = jsDir
    let vnode = buildHtml(html):
      head:
        title: text rendered.genTitle appName
        meta(name="viewport", content="width=device-width, -scale=1.0")
      body:
        tdiv(id = "ROOT"):
          rendered.renderErrors
          rendered.vnode
        genBridgedData(
          appName = appName
        )
        script(src = "/" & jsDir / "main.js")
    result = $vnode
else:
  from std/json import parseJson, to

  proc parseBridgedData*(rendered): BridgedData =
    ## Parses the BridgedData sent by server in a script tag
    new result
    try:
      result = document.
        getElementById(brDataDomJsonId).
        innerText.
        `$`.
        parseJson.
        to BridgedData
    except:
      rendered.addError getCurrentExceptionMsg()
