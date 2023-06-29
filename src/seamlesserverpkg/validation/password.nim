const pattern* = r"""^.{6,32}$"""

when not defined js:
  import std/re
  proc check*(password: string): bool =
    ## Checks if password is correct
    password.match pattern.re
