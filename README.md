# PersonaSphere — Discover Your True Self

Offline personality quizzes with glassmorphism UI, Riverpod state management, progress saving, favorites, onboarding, light/dark themes, confetti results, and shareable text plus generated share cards.

**Tagline:** Understand yourself, unlock your potential.

## Requirements

- [Flutter](https://docs.flutter.dev/get-started/install) (stable channel)
- Android Studio / Xcode (for mobile targets), or use Chrome / Windows desktop for quick runs

## Setup

```bash
cd "path/to/Personality Quiz App"
flutter pub get
dart run flutter_launcher_icons   # regenerates launcher icons from assets/branding/app_icon.png
flutter run
```

Pick a device with `flutter devices`, then e.g. `flutter run -d chrome` or `flutter run -d windows`.

## Project layout

- `lib/core/` — theme, constants  
- `lib/models/` — `QuizModel`, `QuestionModel`, `AnswerOptionModel`, `QuizResultModel`  
- `lib/services/` — JSON loading, scoring (`QuizEngine`), `SharedPreferences` storage, sharing  
- `lib/providers/` — Riverpod (`settingsProvider`, `quizzesProvider`, `favoritesProvider`, …)  
- `lib/screens/` — splash, onboarding, home, quiz, result, settings  
- `lib/widgets/` — glass cards, backdrop, progress bar, share card  
- `assets/data/` — `catalog.json` plus per-quiz JSON files  

## Tests

```bash
flutter test
```

Includes unit tests for scoring and a widget smoke test for the quiz screen.

## Release builds (Google Play)

1. **Versioning:** bump `version:` in `pubspec.yaml` (e.g. `1.0.1+2` → name `1.0.1`, build `2`). Optionally mirror `AppConstants.version` / `buildNumber` in `lib/core/app_constants.dart` for the Settings screen label.

2. **Signing (Android):** configure your keystore and `key.properties` per [Flutter Android signing](https://docs.flutter.dev/deployment/android#sign-the-app).

3. **Build artifacts:**

```bash
# Debug APK (quick install)
flutter build apk --debug

# Release APK
flutter build apk --release

# Play Store bundle (AAB)
flutter build appbundle --release
```

Outputs:

- APK: `build/app/outputs/flutter-apk/`
- AAB: `build/app/outputs/bundle/release/`

## Screenshots (for store listings)

Run the app on an emulator or device, navigate through Splash → Home → a quiz → results, and capture screenshots (Android Studio **Logcat** tool window → **Screen capture**, or OS tools). There is no bundled screenshot folder by default; add your own under e.g. `store/screenshots/` if you use fastlane or manual uploads.

## Permissions

- **Android:** `VIBRATE` is declared for optional haptic-style feedback; no network permission is required for core offline use. Sharing uses the system share sheet.

## Privacy

No authentication, no Firebase, no analytics in this template. All quiz data and preferences stay on-device via `SharedPreferences`.

## Branding

- App display name: **PersonaSphere** (Android `AndroidManifest`, iOS `Info.plist`, web `manifest.json`).  
- Replace `assets/branding/app_icon.png` and re-run `dart run flutter_launcher_icons` to refresh icons.
