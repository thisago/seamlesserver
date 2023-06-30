from std/strformat import fmt

import pkg/karax/vdom
when not defined js:
  import pkg/karax/karaxdsl

when not defined js:
  type
    SsrRendered = ref object
      before*, after*: VNode
type
  Rendered* = ref object
    vnode*: VNode
    title*: string
    when not defined js:
      ssrvnodes*: SsrRendered

using
  self: Rendered

when not defined js:
  func newSsrRendered*: SsrRendered =
    new result
    new result.before
    new result.after

func newRendered*: Rendered =
  new result
  when not defined js:
    result.ssrvnodes = newSsrRendered()

func genTitle*(self; appName: string): string =
  ## Gets the rendered page title
  fmt"{self.title} - {appName}"
