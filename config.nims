switch("path", "$projectDir/../src")
switch("path", "$projectDir/../../src")
switch("path", "$projectDir/../../../src")
switch("path", "$projectDir/../../../../src")

when not defined windows:
  switch("threads", "on")
