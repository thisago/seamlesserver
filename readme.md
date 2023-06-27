<div align=center>

# **SEAMLESSERVER**

#### A web template that backend and frontend are seamless connected!

[About](#about) - [Stack](#stack) - [Features](#features) - [How it Works](#how-it-works) - [License](#license)

</div>

## About

This template implements a basic fullstack system seamless connected between backend and frontend.

The backend renders the **exactly** same page as backend, using same model!

The page switching is made by Javascript, with `History.pushState`, so you can use the whole site without Javascript or browse with the speed of a SPA website

## Stack

This template is built in [Nim language](nimlang) using the following library and frameworks:

- **Web Framework**: [Prologue](https://github.com/planety/prologue)
- **ORM**: [Norm](https://github.com/moigagoo/norm)
- **Backend HTML generation and SPA frontend framework**: [Karax][karax] ([fork used](https://github.com/thisago/karax))

## Features

### Just one HTML model, for frontend and backend

You can pre-render SPA pages in the server side

### Bridged data

The server can send a JSON to frontend seamless.

The server renders a HTML script tag with a JSON on it and the
frontend reads it and deserialize to a [`BridgedData`](bridgedDataDef)

## How it Works

### Rendering

The HTML rendering models are defined at [seamlesserverpkg/renderer/routes](src/seamlesserverpkg/renderer/routes), everything is reused, even states objects are shared!

The renderer receives a reference to a [`State`](stateDef), it contains a instance of [`BridgedData`](bridgedDataDef) and a list of errors (like NodeJS flash messages). It returns an [`Rendered`](renderedDef), an object that contains the rendered `VNode` and the page title.

The server renders the page with a blank state, since it's on server side.

When your browser receive the rendered webpage, it is just a static page, but the Javascript will re-render the page as a SPA application, using the same models defined in backend.

The SPA will change the pages without reloading and the state will be preserved, and even if you reload the page, the state will be stored in your browser's LocalStorage.

## License

This template is free and open source software licensed over MIT license.

<!-- Refs -->

[nimlang]: https://nim-lang.org "Nim Language official website"
[karax]: https://github.com/karaxnim/karax
[bridgedDataDef]: ./src/seamlesserverpkg/renderer/base/bridgedData.nim#L7
[stateDef]: ./src/seamlesserverpkg/renderer/base/state.nim#L4
[renderedDef]: ./src/seamlesserverpkg/renderer/base/rendered.nim#L6
