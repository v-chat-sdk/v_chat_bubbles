# Repository Guidelines

## Project Structure & Module Organization

`lib/v_chat_bubbles.dart` is the package entry point and exports the supported public API. Implementation lives under `lib/src/`: shared models and configuration are in `core/`, visual tokens in `theme/`, drawing code in `painters/`, UI in `widgets/`, media screens in `viewers/`, and helpers in `utils/`. Keep new code in the matching module and update its barrel export when it is public.

Automated tests live in `test/`. The runnable showcase is in `example/`; use it for manual checks across chat styles and platforms. Demo backgrounds are under `example/assets/`, while repository screenshots and design notes belong in `screenshots/` and `doc/`.

## Flutter 3.50 verification workflow

Use the installed project-compatible Flutter 3.50/Dart 3.14 SDK. Keep direct `material_ui`/`cupertino_ui` dependencies consistent with their imports; design widgets no longer come from `flutter/material.dart` or `flutter/cupertino.dart`. Prefer neutral Flutter libraries when design widgets are unnecessary. Preserve this project's architecture and public contracts.

Resolve dependencies from each affected package root with `flutter pub get --no-example`. For a design migration, run `dart fix --apply --code=migrate_design_widgets` and review its output. After every code edit, run these commands sequentially from the affected package root:

```sh
dart fix --apply
dart format .
flutter analyze
```

Fix and format must finish before analysis or tests. Analyzer-only verification is the default. Run a focused test or build when requested or needed to prove a specific behavior change; choose the smallest useful check. Passing analysis does not prove runtime, provider, native linking, or integration behavior. Never suppress maintained-source diagnostics to obtain a pass. Preserve tool-owned generated files.

Existing web runners: `example`. When a run is requested, use the existing web development workflow with one explicitly selected target and port, then inspect it with Playwright MCP. An explicitly requested `flutter build web` is a compile check, separate from the development run. Do not add web targets merely to validate a migration.

Use a reachable physical Android device only when web is unsupported and device execution is requested. No emulator or simulator is authorized. This Linux VPS cannot execute native iOS/macOS builds or assume access to a phone attached to the Mac. Observe the global 500 MB download rule and preserve existing edits, credentials, caches, and running sessions. Do not push, publish, deploy, or run native builds without task authorization.

Use one handwritten class/widget per file; a StatefulWidget and its paired State may share a file. Apply SOLID without speculative abstractions. Keep UI, coordination, domain behavior, transport, persistence, and provider mechanics in their existing layers; use explicit types and correct async ownership/disposal. Do not impose another project’s state management or architecture.


## Coding Style & Naming Conventions

Use null-safe, idiomatic Dart with two-space indentation. Name files `snake_case.dart`, types `UpperCamelCase`, and members `lowerCamelCase`. Public package widgets and configuration types conventionally use the `V` prefix, such as `VBubbleScope` and `VBubbleConfig`. Prefer immutable values, `const` constructors, small reusable widgets, and existing theme/config abstractions. Do not expose implementation files directly when a barrel export is appropriate.

## Testing Guidelines

Tests use `flutter_test`, with `group`, `test`, and `testWidgets`. Name files `*_test.dart` and describe observable behavior, for example `VBubbleFooter renders edited label`. Add a regression test for every bug fix and cover public defaults when adding configuration. There is no enforced coverage threshold; meaningful behavior coverage is required. For visual changes, also exercise the affected styles in `example/`.

## Commit & Pull Request Guidelines

History uses `vX.Y.Z: Summary` for releases and short, behavior-focused subjects for other changes; Conventional Commit prefixes are not required. Keep commits scoped. Pull requests should explain the change, link relevant issues, list validation commands, and call out compatibility concerns. Include screenshots or recordings for UI changes, and update the example, README, or changelog when public behavior changes.

## Local package migration dependencies

The development overrides in `pubspec_overrides.yaml`, `example/pubspec_overrides.yaml` point to migrated sibling packages in the organized workspace. Keep the relative layout when developing this migration. Hosted releases may still expose legacy Material theme types. Before distributing a checkout independently, release compatible dependency versions and update its hosted constraints; do not publish local paths or force incompatible overrides.

The example’s `l10n.yaml` documents a narrow Flutter 3.50 generator exception: SDK-generated delegates still import legacy design libraries. Regenerate them with `flutter gen-l10n`; do not hand-edit generated localization code or extend this exception to maintained source.
