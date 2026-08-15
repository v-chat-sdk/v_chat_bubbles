# Repository Guidelines

## Project Structure & Module Organization

`lib/v_chat_bubbles.dart` is the package entry point and exports the supported public API. Implementation lives under `lib/src/`: shared models and configuration are in `core/`, visual tokens in `theme/`, drawing code in `painters/`, UI in `widgets/`, media screens in `viewers/`, and helpers in `utils/`. Keep new code in the matching module and update its barrel export when it is public.

Automated tests live in `test/`. The runnable showcase is in `example/`; use it for manual checks across chat styles and platforms. Demo backgrounds are under `example/assets/`, while repository screenshots and design notes belong in `screenshots/` and `doc/`.

## Build, Test & Development Commands

- `flutter pub get` resolves package dependencies.
- `dart format .` applies the standard Dart formatter.
- `flutter analyze` runs the `flutter_lints` rules configured in `analysis_options.yaml`.
- `flutter test` runs all package unit and widget tests.
- `flutter test test/bubble_components_test.dart` runs one focused suite.
- `cd example && flutter run` launches the demo for visual and interaction testing.
- `flutter pub publish --dry-run` validates package metadata and publish contents without releasing.

## Coding Style & Naming Conventions

Use null-safe, idiomatic Dart with two-space indentation. Name files `snake_case.dart`, types `UpperCamelCase`, and members `lowerCamelCase`. Public package widgets and configuration types conventionally use the `V` prefix, such as `VBubbleScope` and `VBubbleConfig`. Prefer immutable values, `const` constructors, small reusable widgets, and existing theme/config abstractions. Do not expose implementation files directly when a barrel export is appropriate.

## Testing Guidelines

Tests use `flutter_test`, with `group`, `test`, and `testWidgets`. Name files `*_test.dart` and describe observable behavior, for example `VBubbleFooter renders edited label`. Add a regression test for every bug fix and cover public defaults when adding configuration. There is no enforced coverage threshold; meaningful behavior coverage is required. For visual changes, also exercise the affected styles in `example/`.

## Commit & Pull Request Guidelines

History uses `vX.Y.Z: Summary` for releases and short, behavior-focused subjects for other changes; Conventional Commit prefixes are not required. Keep commits scoped. Pull requests should explain the change, link relevant issues, list validation commands, and call out compatibility concerns. Include screenshots or recordings for UI changes, and update the example, README, or changelog when public behavior changes.
