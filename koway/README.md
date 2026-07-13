# Koway Flutter App

This folder contains the Flutter client for [Koway](../README.md), an
open-source bus route app for Coimbatore. Koway currently focuses on fast,
offline route discovery using community-maintained local data.

## Roadmap

- Map-based route exploration.
- Bus schedules and estimated arrival times.
- Live vehicle tracking when reliable transit data is available.
- Optimise the app for web.

## Development Setup

Install a recent [Flutter SDK](https://docs.flutter.dev/get-started/install)
with Dart 3.9.2 or newer. From this folder, run:

```sh
flutter pub get
flutter run
```

Flutter will ask you to select a device when more than one target is available.

## Code Quality

Format and analyze the project before submitting a change:

```sh
dart format lib test
flutter analyze
```

## Project Structure

| Path | Purpose |
| --- | --- |
| `lib/screens/` | Screen layout, state, and navigation |
| `lib/widgets/` | Small reusable UI components |
| `lib/models/` | Bus route and stop data models |
| `lib/services/` | Local route loading and search logic |
| `lib/theme/` | Shared colors, spacing, radii, and Flutter theme |
| `assets/` | Generated route data consumed by the app |

`MainScreen` owns the selected bottom-navigation tab. Individual screens own
their controllers and filtered route lists. Reusable widgets receive data and
callbacks from those screens.

## Route Data

The source route files live in `../data/routes/`. The files in `assets/` are
generated output and should not be edited by hand.

To rebuild the Flutter assets, run the following from this folder:

```sh
cd ../scripts
python -m pip install jsonschema
python build_routes.py
python hash_routes.py
```

`build_routes.py` validates and combines the route files into
`assets/routes.json`. `hash_routes.py` creates the stop-to-route search index
in `assets/hashed_routes.json`.

## UI Contributions
- Keep widgets and state ownership straightforward for new Flutter developers.
- Preserve route search, navigation, loading, and empty-state behavior.
- Do not display live transit features unless the project has real data for
  them.
- Keep pull requests focused on one screen or reusable widget at a time.

Contribution and licensing information is available in the
[main project README](../README.md).
