from std/strutils import join
from std/strformat import fmt
from std/logging import debug

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

proc genQuery(
  tableName: string;
  keys: openArray[string];
  values: openArray[string];
  operator = "and"
): string =
  ## Generates a query string for provided data
  var query: seq[string]
  for key in keys:
    query.add tableName & "." & key & " = ?"
  result = query.join fmt" {operator} "
  debug result

func toDbValues[T](vals: varargs[T]): seq[DbValue] =
  ## Converts all values to DbValue
  for val in vals:
    result.add dbValue val

proc get*[T](
  table: typedesc[T];
  keys: openArray[string];
  values: openArray[string];
  operator = "and"
): T =
  ## Select the row of table with provided keys and values
  result = new table
  if keys.len == values.len:
    try:
      inDb: dbConn.select(
        result,
        genQuery($table, keys, values, operator),
        values.toDbValues
      )
    except:
      result = nil

proc getAll*[T: ref object](
  table: typedesc[T];
  keys: openArray[string];
  values: openArray[string];
  operator = "and"
): seq[T] =
  ## Select all rows of table with provided keys and values
  result = @[new table]
  if keys.len > 0 and keys.len == values.len:
    try:
      inDb: dbConn.select(
        result,
        genQuery($table, keys, values, operator),
        values.toDbValues
      )
    except:
      result.del 0

proc getAll*[T: ref object](table: typedesc[T]): seq[T] =
  ## Select all rows of table
  result = @[new table]
  try:
    inDb: dbConn.selectAll result
  except:
    result.del 0

proc count*[T: ref object](table: typedesc[T]): int =
  ## Returns how much rows in table
  try:
    inDb: result = dbConn.count table
  except:
    result = -1
