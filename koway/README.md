# Koway

Koway is a simple, open-source Flutter app for finding bus routes in
Coimbatore. It uses local route data and does not claim to provide live
tracking or arrival times.

## What You Can Do

- Find direct buses between two stops.
- Search routes by number, origin, or destination.
- Browse the stops of a route in order.

## Screenshots

| Trip Planner | Routes | Route Details |
| :---: | :---: | :---: |
| <img src="flutter_01.png" alt="Trip planner with direct bus results" width="260"> | <img src="flutter_02.png" alt="Searchable list of Coimbatore bus routes" width="260"> | <img src="flutter_03.png" alt="Route details with an ordered stop timeline" width="260"> |

## Getting Started

Install the [Flutter SDK](https://docs.flutter.dev/get-started/install), open
this folder in a terminal, and run:

```sh
flutter pub get
flutter run
```

Use `flutter analyze` to check the code before submitting a change.

## Route Data

The app reads its route information from `assets/routes.json` and
`assets/hashed_routes.json`. See the [main project README](../README.md) for
contribution and licensing information.
