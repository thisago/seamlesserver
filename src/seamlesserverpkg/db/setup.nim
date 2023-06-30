from seamlesserverpkg/db import DbConn, createTables, insert
from seamlesserverpkg/db/models/user import newUser, ukAdmin

proc setup*(conn: DbConn) =
  ## Creates all tables
  conn.createTables newUser()

  block createAdmin:
    var user = newUser(
      username = "admin",
      email = "admin@localhost",
      password = "admin",
      kind = ukAdmin
    )
    conn.insert user
