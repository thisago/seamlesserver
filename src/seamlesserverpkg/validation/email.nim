const pattern* = r"""^(([^<>()[\]\.,;:\s@"]+(\.[^<>()[\]\.,;:\s@"]+)*)|(".+"))@(([^<>()[\]\.,;:\s@"]+\.)+[^<>()[\]\.,;:\s@"]{2,})$"""

when not defined js:
  import std/re
  proc check*(email: string): bool =
    ## Checks if email is correct
    email.match pattern.re
