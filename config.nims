for i in 1..3:
  var path = "$projectDir/"
  for _ in 0..i: path.add "../"
  switch("path", path & "src")
