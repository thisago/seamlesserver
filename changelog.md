# Changelog

## Version alpha 0.11.1 (20/09/2023)

- Renamed `dynamicLink` parameter to disable JS loading from `inSpa` to `useJs`

## Version alpha 0.11.0 (20/09/2023)

- Added auto project renaming
- Added CSS compilation to `r` Nimble task
- Removed all uppercase letters in `seamlesserver` to allow renamer task works well

## Version alpha 0.10.0 (17/09/2023)

- Fixed app name
- Added styling
- Added Sass compilation task
- Added compiled Sass linking task to development purposes
- Fixed some tasks
- Added DOCTYPE tag in server side HTML
- Fixed HTML includes url to absolute path
- Moved assetsDir and jsDir definition from .env to compile time
- Fixed sw.js route
- Session is now httpOnly
- 404 page now generate a main element

## Version alpha 0.9.0 (17/09/2023)

- Fixed compilation issues
  - Wrong JS karax submodules importing in server
  - Added `db_connector` dependency

## Version alpha 0.8.0 (28/07/2023)

- Adapted to official Karax version

## Version alpha 0.7.0 (30/06/2023)

- Removed "test" text in SSR before and after nodes
- Added State persistance in localStorage
- Server sends HTTP code 401 when login is incorrect
- Server sends HTTP code 400 when registration was failed, 409 when username or email already exists and 500 when some DB error occurred
- Instead of redirecting same page from POST to GET, it now renders the GET page in the POST. Faster loading
- Added PWA support (Oh, took a lot of time...)
- Added favicons
- Added missing files ignored by `.gitignore`
- Implemented service worker register in Nim
- Added creation date info in user

## Version alpha 0.6.0 (30/06/2023)

- Implemented login POST
- Removed debugging echoes
- Added a option to disable the pushState in links using `dynamicLink` proc
- Added a flash for logging out
- Hide login and register link from header when logged in

## Version alpha 0.5.0 (29/06/2023)

- Added password validation
- Fixed email regex validator
- Added flash auto deleting (animation will be cool)
- Implemented user registration
  - Checks if username or email was been used
- Base64 encoding the BridgedData
- Added optional VNode in server-side before and after `div#ROOT` that frontend won't override
- Fixed session persistance by using `memorysession` middleware
- Added page blocking in front/backend; example: access login page just when you're logged off
- Increased server's flashes time to 5s
- Added logout route
- Fixed flash auto deleting

## Version alpha 0.4.0 (29/06/2023)

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

## Version alpha 0.3.0 (27/06/2023)

- Removed debug middleware when not in debug mode
- Added configurable JS filename
- Improved and added more nimble tasks
- Header and footer receives the state
- Added links to header
- Added login form HTML

## Version alpha 0.2.0 (27/06/2023)

- Added SPA routing without reloading
- Added "flash" errors
- Added BridgedData, data which is provided by backend, directly to frontend
- Removed useless extra tdiv at frontend rendering
- Added header and footer
- Added blank register page
- Fixed BridgedData behavior, now it's inside of State object
- Moved the BridgedData, Errors, Rendered and State to their own module
- Server side renderer now receives the renderer function, to run it with a blank State.

## Version alpha 0.1.0 (26/06/2023)

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
