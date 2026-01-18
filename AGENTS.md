# Repository Guidelines

## Project Structure and Module Organization
- `lib/v_chat_bubbles.dart` is the public entry point that exports the package API.
- `lib/src/core` holds enums, models, configs, and callbacks that define behavior.
- `lib/src/widgets`, `lib/src/theme`, `lib/src/painters`, `lib/src/utils`, and `lib/src/viewers` contain the UI layer, theming, drawing logic, helpers, and media viewers.
- `example/` is a runnable Flutter app for manual and visual testing.
- `test/` contains automated tests (for example `test/v_chat_bubbles_test.dart`).
- `screenshots/` and `docs/` store README assets and design notes.

## Build, Test, and Development Commands
- `flutter pub get` installs dependencies for the package and example app.
- `flutter analyze` runs static analysis using `flutter_lints`.
- `flutter test` runs the full test suite.
- `flutter test test/v_chat_bubbles_test.dart` runs a single test file.
- `cd example && flutter run` launches the demo app for UI validation.

## Coding Style and Naming Conventions
- Follow Dart formatting (`dart format .`); the standard is 2-space indentation.
- Keep file names in `snake_case` and public types in `PascalCase`.
- Public widgets and configs use the `V` prefix (for example `VBubbleScope`, `VTextBubble`).
- Place new bubble widgets in `lib/src/widgets`, painters in `lib/src/painters`, and shared data in `lib/src/core`.

## Testing Guidelines
- Tests use the `flutter_test` framework from `dev_dependencies`.
- Name tests with the `*_test.dart` suffix and place them under `test/`.
- Add or update tests when changing bubble layout logic, gesture handling, or callbacks.

## Commit and Pull Request Guidelines
- Follow existing commit patterns: release commits use `vX.Y.Z: <summary>`; other commits are short, descriptive sentences.
- Pull requests should include a clear summary, linked issues (if any), and the exact commands run.
- Include screenshots or short recordings for any visual changes to bubbles or themes, and update the example app when behavior changes.

## Agent Notes
- `CLAUDE.md` documents architecture and common commands; keep it in sync when adding new core modules or workflows.
