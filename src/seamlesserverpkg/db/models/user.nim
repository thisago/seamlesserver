import pkg/norm/[
  model,
  pragmas
]

from ../../auth import makeSalt, makePassword

type
  User* = ref object of Model
    ## User DB model
    username* {.unique.}: string
    email* {.unique.}: string
    password*, salt*: string

    internal_kind*: int # User kind (internal)

  UserKind* = enum
    ukGhost,
    ukUser,
    ukAdmin

using
  user: User # Immutable user
  muser: var User # Mutable user

func kind*(user): UserKind =
  ## Get user kind
  UserKind(user.internal_kind)
func `kind=`(muser; rank: UserKind) =
  # Set user kind
  muser.internal_kind = ord rank

proc newUser*(
  username, email, password: string;
  kind = ukGhost
): User =
  ## Creates new user
  new result
  result.username = username
  result.email = email
  result.kind = kind

  result.salt = makeSalt()
  result.password = makePassword(password, result.salt)

proc newUser*: User =
  ## Creates new blank user
  newUser("", "", "")

import ../../db

proc get*(_: type User; email = ""; username = ""): User =
  ## Get the user by email or username
  var
    keys: seq[string]
    values: seq[string]
  if email.len > 0:
    keys.add "email"
    values.add email
  if username.len > 0:
    keys.add "username"
    values.add username
  if keys.len > 0:
    result = User.get(keys, values)
