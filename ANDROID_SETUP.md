# Android setup for Google Play

This archive contains Flutter source files. To generate Android/iOS platform folders:

```bash
flutter create .
flutter pub get
flutter run
```

Before Google Play release:

1. Set application id in `android/app/build.gradle`.
2. Add launcher icons.
3. Configure signing in `android/key.properties` and Gradle.
4. Build AAB:

```bash
flutter build appbundle --release
```
