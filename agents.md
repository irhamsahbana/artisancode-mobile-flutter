# Mobile HR Agent Guide

## Core Expectations

- Be objective and truthful, even if the feedback is uncomfortable.
- When editing files, always use absolute paths.
- Explain why a file change is being made.
- When generating code, add comments in English.

## Shell And Commands

- Use `bash`, `zsh`, or `fish` for shell commands.
- Prefer `flutter` and `dart` CLI tools directly.
- Common commands:
  - `flutter pub get`
  - `flutter analyze`
  - `flutter test`
  - `flutter run`

## Stack And Direction

- Primary stack: Flutter, Dart, Material 3.
- Current product direction: employee mobile app with attendance as the first vertical slice.
- The backend contract lives in `/Users/codebeast/Documents/src/artisancode/artisancode-backend-go/docs/mobile_attendance_v1.md`.
- Prefer simple, maintainable architecture while the app foundation is still taking shape.

## Project Structure

- Keep all application code under `lib/`.
- Use a feature-oriented structure with clean architecture when implementation starts growing, for example:
  - `lib/app/` for app bootstrap, theme, routing, and shared shell
  - `lib/features/` for business features such as auth, attendance, and profile
  - `lib/shared/` for truly shared UI, networking, utilities, and constants
- Inside each feature, prefer `presentation`, `domain`, and `data` layers once the feature has enough complexity to justify them.
- Leave generated platform files under `android/`, `ios/`, `macos/`, `linux/`, `windows/`, and `web/` untouched unless the task explicitly requires platform configuration.
- Add new top-level folders only when they create a clear architectural boundary.

## UI And State

- Reuse shared widgets before creating one-off components.
- Keep widgets small and composable.
- Every network-driven screen should have clear loading, empty, error, and success states.
- Preserve mobile-first ergonomics by default: tap targets, safe areas, keyboard behavior, and responsive layout decisions all matter.

## Data And API Patterns

- Treat the Go backend as the source of truth for auth, employee context, and attendance data.
- Align request and response handling with the mobile attendance endpoints already available:
  - `GET /me`
  - `GET /me/employee`
  - `GET /me/shift-today`
  - `GET /attendance-summary/today`
  - `GET /attendance-policy`
  - `GET /attendance-logs`
  - `POST /attendance-logs/check-in`
  - `POST /attendance-logs/check-out`
- Keep API models separate from UI presentation models when that separation improves clarity.
- Centralize HTTP client setup, auth token handling, and error mapping so features do not reimplement them.

## Verification Checklist

- After meaningful app changes, run the smallest relevant checks first.
- Default verification order:
  1. `flutter analyze`
  2. `flutter test`
  3. targeted manual run for the affected flow when UI behavior changes
- If auth or attendance flows are touched, verify:
  - login persistence
  - unauthorized state handling
  - loading and retry behavior
  - check-in and check-out happy path and rejected path

## Documentation Maintenance

- The AI agent is authorized to update `docs/` files to keep them accurate.
- When project structure or conventions change, update the related docs in the same task when practical.
- Keep docs lightweight, practical, and implementation-oriented while the app is still in the foundation stage.
