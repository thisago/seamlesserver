when not defined js:
  {.fatal: "This module is designed to work just in Javascript backend".}

# TODO: Implement in Nim
{.emit: """
if ("serviceWorker" in navigator) {
  navigator.serviceWorker.register("/sw.js").then(swRegistered => {
    console.log("[ServiceWorker**] - Registered");
  });
}
""".}
