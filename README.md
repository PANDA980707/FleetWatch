# FleetWatch

FleetWatch — mobile app for seafarers and crewing agencies. It includes:

- job board for maritime vacancies
- crewing company listings
- sea-time / cenz calculator
- reviews and ratings
- profile / PRO tools
- auth flow with Firebase-like backend endpoint integration

## Tech stack

- Flutter
- Riverpod
- Go Router
- Shared Preferences
- HTTP

## Project structure

- `lib/main.dart` — app entry point
- `lib/app_router.dart` — routing configuration
- `lib/screens/` — main screens
- `lib/features/auth/` — authentication screens and provider

## Run locally

```bash
flutter pub get
flutter run
```

## Build APK release

```bash
flutter clean
flutter pub get
flutter build apk --release
```

The APK will be generated in:

```bash
build/app/outputs/flutter-apk/app-release.apk
```

## Notes

This project is already connected to the backend base URL defined in:

- `lib/features/auth/auth_provider.dart`

Default API base:

```dart
const String apiBase = 'https://fleetwatch-0s4w.onrender.com';
```

If the server is offline, login and registration may fail until the backend is available.

## Useful commands

```bash
flutter analyze
flutter test
flutter pub outdated
```
