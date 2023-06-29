import seamlesserverpkg/db
import seamlesserverpkg/db/models/user

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
