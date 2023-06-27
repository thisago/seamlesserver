include pkg/karax/prelude

import ../config

when not defined js:
  proc baseHtml*(bodyNode: VNode): string =
    withConf:
      let appName = appName
    let vnode = buildHtml(html):
      head:
        title: text appName
        meta(name="viewport", content="width=device-width, initial-scale=1.0")
      body:
        bodyNode
    result = $vnode
