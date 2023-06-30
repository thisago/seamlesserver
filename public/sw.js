// Service Worker
const cacheName = "pwa-share-api"
const filesToCache = [$filesToCache]

self.addEventListener("install", (e) => {
  console.log("[ServiceWorker**] - Install")
  e.waitUntil(
    caches.open(cacheName).then((cache) => {
      console.log("[ServiceWorker**] - Caching app shell")
      return cache.addAll(filesToCache)
    })
  )
})

self.addEventListener("activate", (event) => {
  caches.keys().then((keyList) => {
    return Promise.all(
      keyList.map((key) => {
        if (key !== cacheName) {
          console.log("[ServiceWorker] - Removing old cache", key)
          return caches.delete(key)
        }
      })
    )
  })
  event.waitUntil(self.clients.claim())
})

self.addEventListener("fetch", (evt) =>
  evt.respondWith(fetch(evt.request).catch(() => caches.match(evt.request)))
)
