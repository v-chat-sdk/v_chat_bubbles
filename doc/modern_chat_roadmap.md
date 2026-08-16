# Modern Chat Feature Roadmap

This roadmap tracks the package-level work required to support current chat
experiences while preserving the existing public API. Each task includes its
minimum completion proof; examples and documentation are part of the feature,
not follow-up work.

## Foundation

- [x] Add automatic message grouping with deterministic first/middle/last
  positions, sender and time-window boundaries, and legacy `isSameSender`
  compatibility.
- [x] Add adaptive pointer, keyboard, secondary-click, and touch interactions.
- [x] Wire minimum tap targets, high-contrast rendering, and animation settings.
- [x] Expand widget, semantics, RTL, hover, keyboard, and regression tests.

## Message Experience

- [x] Model delivery lifecycle details: queued/sending/sent/delivered/read/error,
  per-recipient receipts, edit history, and retry metadata.
- [x] Add protected content: view-once media, spoilers, and expiry countdowns.
- [x] Upgrade reactions with actor details, custom emoji, and overflow handling.
- [x] Add selective quote ranges, nested reply context, and thread summaries.
- [x] Add translated-text and voice-transcript presentation states.
- [x] Add dedicated GIF and animated-sticker playback states.
- [x] Add richer link previews and HD/media-collection presentation.
- [x] Add checklist, event, and live-location collaborative messages.

## Release Readiness

- [x] Export every supported public type from package barrels.
- [x] Update the example, README, and changelog with migration-safe examples.
- [x] Format changed Dart sources; run `flutter analyze`, `flutter test`, example
  analysis/tests/build, and `flutter pub publish --dry-run`.
- [x] Audit all tasks against tests and public API compatibility before release.
