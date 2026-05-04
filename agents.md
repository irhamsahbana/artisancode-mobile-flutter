# Mobile HR Agent Guide

## Core Expectations

- Be objective and truthful, even if the feedback is uncomfortable.
- When editing files, always use absolute paths.
- Explain why a file change is being made.
- When generating code, add comments in English.
- Before using Serena symbolic tools or Serena memories for mobile work, activate the Serena project at `mobile-hr/artisan_hr/`. Do not operate Serena on the umbrella workspace for mobile tasks.

## Shell And Commands

- Use `bash`, `zsh`, or `fish` for shell commands.
- Prefer `flutter` and `dart` CLI tools directly.
- Prefer the repo `Makefile` when it already captures device selection or `API_BASE_URL` / `ANDROID_API_BASE_URL` defaults.
- Common commands:
  - `make help`
  - `flutter pub get`
  - `flutter analyze`
  - `flutter test`
  - `make check`
  - `flutter run`
  - `make pub-get`
  - `make analyze`
  - `make test`
  - `make run`
  - `make ios-simulators`
  - `make open-ios-simulator`
  - `make run-ios-simulator`
  - `make run-ios-profile`
  - `make run-ios-release`
  - `make run-android-emulator`
  - `make run-macos`
  - `make run-chrome`
  - `make clean`
  - `make doctor`
  - `make devices`
- For local backend testing, prefer `make run` or the `make run-*` targets when you want the repo's default `--dart-define` base URL wiring. Override `API_BASE_URL` or `ANDROID_API_BASE_URL` on the command line instead of editing app code.
- Override `IOS_SIMULATOR`, `IOS_DEVICE`, or `FLUTTER` on the command line when needed instead of editing the repo `Makefile`.

## Stack And Direction

- Primary stack: Flutter, Dart, Material 3.
- Current product direction: employee mobile app with attendance as the first vertical slice.
- The backend contract lives in `../../artisancode-backend-go/docs/mobile_attendance_v1.md`.
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
- Prefer `package:artisan_hr/...` imports for code under `lib/` and avoid relative imports unless there is a real Dart language constraint.
- Keep import sections ordered as `dart:`, then `package:`, then relative only if unavoidable, and remove unused imports during refactors.

## UI And State

- Reuse shared widgets before creating one-off components.
- Keep widgets small and composable.
- Every network-driven screen should have clear loading, empty, error, and success states.
- Prefer non-blocking screen hydration for network-driven screens. Enter the screen first, then load section data inside the screen whenever the action does not require blocking the whole app.
- Use skeleton states that preserve the final layout instead of blank space or full-screen spinners when a screen is still hydrating.
- When refreshing existing data, prefer keeping the current content visible with inline progress rather than clearing the screen back to an initial loading state.
- Preserve mobile-first ergonomics by default: tap targets, safe areas, keyboard behavior, and responsive layout decisions all matter.
- Do not hardcode `fontSize` values in widgets. Prefer the app typography scale from `Theme.of(context).textTheme` and adjust emphasis with semantic styles or font weight instead of fixed sizes.
- Read `docs/ui_branding.md` before changing app branding, themed surfaces, splash screens, app icons, dark mode, or major visual hierarchy.
- The current mobile brand direction is `Presense`, not `Artisan HR`, and visual changes should stay aligned with the teal-mint identity already implemented in the app.
- New UI work must preserve accessible contrast in both light mode and dark mode. Avoid low-contrast outlined buttons, low-emphasis text on tinted surfaces, and bottom sheets or dialogs that stay light-themed while the app is in dark mode.
- Avoid duplicated user-facing copy in the same screen section. If a hero, status card, or onboarding step already communicates the message, do not repeat the same sentence in secondary chips or helper text unless it adds new information.
- If you change app icons or launch visuals, keep Android, iOS, and web assets consistent with each other.

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
- Multi-language already exists. Read `docs/localization.md` before changing app language flow, ARB files, or localized API handling.
- App locale source of truth is `lib/app/app_controller.dart`.
- `ApiClient` already sends `Accept-Language`. Do not add per-feature language header logic.
- Localized UI copy should come from ARB/gen-l10n output via `context.l10n`.
- If branding or UX copy changes, update both locales and keep the tone concise, direct, and non-redundant.

## Verification Checklist

- After meaningful app changes, run the smallest relevant checks first.
- `make check` is the repo wrapper for `flutter analyze` and `flutter test`.
- Prefer the `make run-*` targets for local backend testing when you want the repo's default `--dart-define` base URL behavior instead of wiring it manually.
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
- The AI agent is authorized to update `agents.md` when workflow expectations, coding conventions, or agent instructions need to stay aligned with the implementation.
- When project structure or conventions change, update the related docs in the same task when practical.
- When a task changes how future mobile work should be executed, documented, or reviewed, update the relevant `agents.md` and `docs/` files in the same task when practical.
- Keep docs lightweight, practical, and implementation-oriented while the app is still in the foundation stage.
- Serena startup sequence for mobile tasks is: activate project `mobile-hr/artisan_hr/`, check onboarding/memory availability, read relevant memories, then begin symbol navigation or edits.
