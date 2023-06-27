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
