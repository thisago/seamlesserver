# Changelog

## Version alpha 0.0.3 (27/06/2023)

- Removed debug middleware when not in debug mode

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
