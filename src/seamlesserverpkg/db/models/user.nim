import pkg/norm[
  model,
  pragmas
]

from seamlesserverpkg/auth import genSalt, hashPassword

type
  User* = ref object of Model
    ## User DB model
    username* {.unique.}: string
    email* {.unique.}: string
    password*, salt*: string

    internal_kind*: int # User kind (internal)

  UserKind* = enum
    ukGhost,
    urUser,
    urAdmin

using
  user: User # Immutable user
  muser: var User # Mutable user

func kind*(user): UserKind =
  ## Get user kind
  UserRank(user.internal_kind)
func `kind=`(muser; rank: UserKind) =
  # Set user kind
  muser.internal_kind = ord rank

proc newUser*(
  username, email, password: string;
  rank = ukGhost;
): User =
  new result
  result.username = username
  result.email = email
  result.rank = rank

  result.salt = genSalt()
  result.password = makePassword(password, result.salt)
