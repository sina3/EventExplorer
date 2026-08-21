# EventExplorer

An iOS app (SwiftUI + MVVM) that shows a list of nearby events, backed by a mock REST API. Supports bookmarking events, caches images, shows distance to each event, and can open an event's location in Apple Maps. The backend is a local `json-server` mock.

## Running the mock API

```
cd mock-api && npm install && npm run mock
```

This runs json-server on port 3001 and serves events from `mock-api/db.json` at `http://localhost:3001/events`. The iOS Simulator can reach it directly through `localhost`, no extra setup needed.

## Running the app

1. Start the mock API first (above) and leave it running.
2. Open `EventExplorer.xcodeproj` in Xcode.
3. Select the `EventExplorer` scheme and run it on a simulator.

## Architecture

- **Pattern:** MVVM, with the views talking to protocol-based services instead of concrete types. View models are `@Observable` and get their dependencies (like `EventsServiceProtocol`) passed in through their initializer, so they're easy to swap out in tests.
- **Concurrency:** Networking uses `async/await`. `ImageCache` is an `actor`, since it's shared mutable state and this avoids having to manage data races manually.
- **Persistence:** `PersistenceStore` wraps a SwiftData `ModelContext` and only exposes simple methods (`toggleBookmark`, `isBookmarked`, `bookmarkedIds`). The views never touch `ModelContext` or `@Query` directly, which makes the store easy to test on its own.

## Networking

The base URL is `http://localhost:3001` and gets passed into `EventsAPIClient` instead of being hardcoded everywhere.

## Testing

Tests are written with Swift Testing, which keeps the syntax simple compared to XCTest.

What's covered right now:
- `EventsListViewModelTests` — checks the `.loaded`/`.failed` states and that bookmark ids get refreshed correctly.
