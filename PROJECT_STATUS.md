# Ship Hours Project Status

Current package: integrated Flutter source archive.

## Included

- Flutter app source in `lib/`
- Clean layered structure: app, core, domain, data, presentation, l10n
- Hive local persistence
- Monthly calendar
- Day screen with 24 hours and `:00` / `:30` slots
- Regular, overtime and total hour calculations
- Regular rate, overtime rate and currency settings
- Monthly statistics
- Light and dark themes
- 14 languages
- App logo image in `assets/images/logo.png`
- Unit test for hour calculation

## How to turn this into a full Flutter project

Run inside this folder on a computer with Flutter installed:

```bash
flutter create .
flutter pub get
flutter analyze
flutter test
flutter run
```

## Important note

This archive was assembled without running Flutter tooling in this environment, because Flutter SDK is not installed here. The source files were checked for structure and obvious consistency, but final compilation must be verified with `flutter analyze` and `flutter run` on a device or emulator.
