switch("path", "$projectDir/../src")
switch("define", "ssl")

when not defined windows:
  switch("threads", "on")

when not defined js:
  switch("mm", "refc") # https://github.com/planety/prologue/issues/227#issuecomment-1696656473
  switch("deepcopy", "on")
  switch("define", "lto")
