import pkg/norm/sqlite
export sqlite

import std/locks

var dbLock*: Lock
initLock dbLock

var dbConn* {.guard: dbLock.}: DbConn

template inDb*(body: untyped) =
  ## This is a simple template to edit db using locks to be `gcsafe`
  {.gcsafe.}:
    withLock dbLock:
      body

from std/strutils import join
from std/strformat import fmt

proc getFromDb*[T](
  table: typedesc[T];
  keys: openArray[string];
  values: varargs[string],
  operator = "and",
): T =
  let tableName = astToStr table
  var query: seq[string]
  for key in keys:
    query.add tableName & "." & key & " = ?"
  result = new table
  var vals: seq[DbValue]
  for val in values:
    vals.add dbValue val
  inDb: dbConn.select(
    result,
    query.join fmt" {operator} ",
    vals
  )
