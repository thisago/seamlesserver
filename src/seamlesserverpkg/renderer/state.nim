type
  State* = ref object
    ## State of frontend page

func newState*: State =
  ## Creates new state
  new result
