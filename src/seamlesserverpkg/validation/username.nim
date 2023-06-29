const pattern* = r"""^.{,16}$"""

when not defined js:
  import std/re
  proc check*(username: string): bool =
    ## Checks if username is correct
    username.match pattern.re
