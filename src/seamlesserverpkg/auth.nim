import pkg/checksums/bcrypt

# import pkg/hmac

proc makeSalt*: string =
  ## Create new salt
  $generateSalt(8)

# Password generation from https://github.com/nim-lang/nimforum/blob/master/src/auth.nim#L45
proc makePassword*(password, salt: string): string =
  ## Create the password hash with given salt
  if password.len == 0:
    return
  $password.bcrypt salt.parseSalt
