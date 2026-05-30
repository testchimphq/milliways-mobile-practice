# Milliways Demo App

  <img src="./docs/screenshot.png" alt width="300" align="right" style="margin-left: 3em; margin-bottom: 3em; border: 2px solid #444; border-radius: 12px; padding: 4px;" />

A demo restaurant stack inspired by The Restaurant at the End of the Universe: **iOS** (SwiftUI under `ios/`), **Android** (Kotlin under `android/`), and a shared **Node** backend.

## Repository layout

| Path | Contents |
|------|----------|
| `backend/` | Node demo API and Docker image |
| `ios/` | Xcode project, app sources, and `Makefile` |
| `android/` | **Kotlin + Compose** app (`:app`), same flows as iOS |
| `guide/` | QA training guide for TestChimp workflows — start with **`guide/TESTING_GUIDE.md`** |

## Purpose

This is a **starter app** for learning [TestChimp](https://testchimp.io). Fork it and add your own SmartTests, test plans, TrueCoverage instrumentation, and CI workflows from scratch.

The app features a food ordering flow with a space-themed menu, shopping cart, delivery tracking, and user account — providing various UI elements and scenarios to practice mobile testing.

## Known Issues

This application contains intentionally placed bugs for testing purposes.

## Getting Started

1. Clone the repository
2. Start the demo backend with Docker:
   ```bash
   docker compose up --build -d
   ```
3. Open `ios/Milliways.xcodeproj` in Xcode
4. Build and run on iOS Simulator or real device

The local API is exposed at `http://localhost:3001` and the Postgres database is exposed at `localhost:5432`. The iOS Simulator can reach the API through `localhost`; a physical device needs the Mac's LAN IP instead.

The backend is intentionally simple for demo purposes. It stores email/password credentials directly in Postgres, seeds the menu on startup, persists orders, and exposes order status checks.

## Building iOS with Make

Run these from the `ios/` directory (or pass `-C ios` from the repo root):

```bash
cd ios
make build     # Build for simulator
make run       # Build, install, and launch on iPhone 17 Pro simulator
make ipa       # Build unsigned IPA
make clean     # Clean build artifacts
```

From repo root: `make -C ios build`, etc.

## Android app

See **`android/README.md`**. Open the `android/` folder in Android Studio, create `android/local.properties` with your SDK path, start the backend (`docker compose up` from repo root), then run on an emulator (API uses `10.0.2.2:3001` by default).

## Community

Join our [Slack](https://join.slack.com/t/mobile-next/shared_invite/zt-37fdhc001-CjZkz8QIZB8dSi486~F0uA), let's talk.
