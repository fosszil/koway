<h1>
  <img src="koway/assets/images/koway_logo.png" alt="Koway logo" width="48" align="left">
  Koway
</h1>

<br clear="left">

Koway is an open-source, community-driven bus route app for Coimbatore, built
with Flutter.

## Features

- Find direct and indirect buses between two stops.
- Search routes by number, origin, or destination.
- View each route's ordered stop list.

The current app is focused on fast route discovery from local route data.
Upcoming work includes map-based exploration, schedules, estimated arrival
times, and live vehicle tracking when reliable transit data is available.

## Getting Started

Install the [Flutter SDK](https://docs.flutter.dev/get-started/install), then
run the app from the Flutter project folder:

```sh
cd koway
flutter pub get
flutter run
```

To create a production build, choose a target platform:

```sh
flutter build apk
flutter build web
```

For Flutter-specific development notes, project structure, route-data scripts,
and contribution guidance, see the [Flutter project README](koway/README.md).

## Screenshots

| Trip Planner | Routes | Route Details |
| :---: | :---: | :---: |
| <img src="koway/flutter_01.png" alt="Trip planner with direct bus results" width="260"> | <img src="koway/flutter_02.png" alt="Searchable list of Coimbatore bus routes" width="260"> | <img src="koway/flutter_03.png" alt="Route details with an ordered stop timeline" width="260"> |

## Contributing

We are currently accepting changes for adding routes and editing existing
routes. Feel free to add or work on new features and bugs.

## License

The repository, excluding data, and all the code in it is licensed under the
[MIT License](LICENSE).
