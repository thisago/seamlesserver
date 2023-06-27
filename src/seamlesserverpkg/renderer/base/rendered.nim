from std/strformat import fmt

include pkg/karax/prelude

type
  Rendered* = ref object
    vnode*: VNode
    title*: string

using
  self: Rendered

func genTitle*(self; appName: string): string =
  ## Gets the rendered page title
  fmt"{self.title} - {appName}"
