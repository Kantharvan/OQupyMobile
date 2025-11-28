# OQUPY Mobile

Flutter app for studio/space booking with phone OTP login, Riverpod state, go_router navigation, and REST/Firebase-ready data models.

## Setup
1. Install Flutter (stable) and Android/iOS toolchains.
2. Install FlutterFire CLI if using Firebase: `dart pub global activate flutterfire_cli`.
3. Add missing Firebase config (if needed): run `flutterfire configure --project <id> --platforms ios,android --out lib/firebase_options.dart` and switch App Check providers in `lib/main.dart` to non-debug for prod.
4. Install deps: `flutter pub get`.
5. Run: `flutter run -d <device-id>`.

## Auth
- Phone OTP UI in `lib/features/auth/presentation/{login_screen.dart,otp_screen.dart}`.
- Auth flow hooks: `AuthRepository.requestOtp/verifyOtp` (replace placeholders with real API).

## Tech
- Flutter, Riverpod, go_router, Dio.
- REST repositories for auth/studios/bookings/blockouts (see `lib/features/*/data`).
- Dark orange theme in `lib/theme.dart`.

## Notes
- `.gitignore` excludes build outputs, editor files, secrets (`lib/firebase_options.dart`). Keep those local.+
