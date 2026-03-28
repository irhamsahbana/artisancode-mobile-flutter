# Mobile HR Tech Stack

## Runtime

- Flutter
- Dart `^3.11.4`
- Material 3 as the baseline design system

## Current Package State

Dependencies are intentionally minimal right now:

- `flutter`
- `flutter_test`
- `flutter_lints`

Add packages only when they solve an active implementation need.

## Likely Near-Term Additions

These are candidates, not final decisions:

- state management:
  - `flutter_riverpod` or another team-approved pattern
- routing:
  - `go_router`
- networking:
  - `dio` or `http`
- storage:
  - `flutter_secure_storage` for tokens
- serialization:
  - `json_serializable` with `build_runner`

Choose tools that keep onboarding simple and testing straightforward.

## API Environment

The mobile app will target the Go backend in `/Users/codebeast/Documents/src/artisancode/artisancode-backend-go`.

At minimum, the mobile setup will eventually need:

- an API base URL strategy for emulator, simulator, and physical device usage
- an auth token persistence strategy
- consistent error mapping for mobile-friendly UX

## Quality Tooling

Use these baseline checks:

- `flutter analyze`
- `flutter test`

Add heavier tooling only when the project clearly benefits from it, such as golden tests, integration tests, or code generation.
