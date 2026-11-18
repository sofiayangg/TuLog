# TuLog

TuLog is a beginner-friendly Flutter sleep tracker. It records bedtime and
wake-up time, calculates sleep duration (including sleep that passes midnight),
and saves one sleep record per calendar day on the device.

## Run the app

1. Install Flutter and set up an Android emulator or connect a device.
2. Open this folder in Visual Studio Code.
3. In the terminal, run:

   ```sh
   flutter pub get
   flutter run
   ```

The app also includes iOS and web scaffolding. Platform-specific iOS builds
require macOS and Xcode.

## Project files

- `lib/main.dart` — app theme, navigation, loading, and save coordination.
- `lib/models/sleep_record.dart` — sleep record model and time calculations.
- `lib/services/sleep_storage.dart` — local JSON storage using shared preferences.
- `lib/screens/home_screen.dart` — dashboard and daily sleep goal.
- `lib/screens/tracker_screen.dart` — time selection and save form.
- `lib/screens/history_screen.dart` — saved sleep records.
- `lib/screens/tips_screen.dart` — simple sleep reminders.
- `test/widget_test.dart` — duration and basic app-flow tests.

The default sleep goal is 8 hours. Saving another record for the same date
replaces that day's record. Data stays on the device and is not synced.
