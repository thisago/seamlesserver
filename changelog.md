# Changelog

## Version alpha 0.0.4 (29/06/2023)

- Added `Model.getAll` DB query function
- Added register form
- Added `BridgedData.devData` for development purposes (TODO: Remove it later)
- Added debug user listing in home
- Renamed routes serverside `render` to `get`
- Fixed modules imports to absolute paths
- Added email validation
- Added POST route for registration (not implemented)
- Fixed 404 error page code
- Removed `State.errors` and replaced it by `BridgedData.flashes`

## Version alpha 0.0.3 (27/06/2023)

- Removed debug middleware when not in debug mode
- Added configurable JS filename
- Improved and added more nimble tasks
- Header and footer receives the state
- Added links to header
- Added login form HTML

## Version alpha 0.0.2 (27/06/2023)

- Added SPA routing without reloading
- Added "flash" errors
- Added BridgedData, data which is provided by backend, directly to frontend
- Removed useless extra tdiv at frontend rendering
- Added header and footer
- Added blank register page
- Fixed BridgedData behavior, now it's inside of State object
- Moved the BridgedData, Errors, Rendered and State to their own module
- Server side renderer now receives the renderer function, to run it with a blank State.

## Version alpha 0.0.1 (26/06/2023)

- Added user DB model
- Added auth hashing
- Added server rendering
- Added homepage and 404 renderer
- Added logging middleware
- Added env config
- Added session middleware
- Added base HTML
- Added frontend routing
- Added SQLite database
- Updated password hashing
