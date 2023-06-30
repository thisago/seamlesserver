import pkg/checksums/bcrypt

proc makeSalt*: string =
  ## Create new salt
  $generateSalt(8)

proc makePassword*(password, salt: string): string =
  ## Create the password hash with given salt
  if password.len == 0:
    return
  $password.bcrypt salt.parseSalt

proc isPasswordSame*(plainPass, hashedPass, salt: string): bool =
  ## Checks if the plain text password is same as hashed pass with provided salt
  result = false
  if plainPass.len == 0:
    return
  result = hashedPass == $plainPass.bcrypt salt.parseSalt
