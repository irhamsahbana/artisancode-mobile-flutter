# Mobile HR Architecture

## Purpose

`artisan_hr` is the employee-facing mobile application for the Artisancode ecosystem. The first release focus is attendance, built on top of attendance v1 and the mobile readiness endpoints already available in the Go API.

This app should grow from a narrow but reliable core:

- employee user authentication
- employee context bootstrap
- today attendance summary
- attendance history
- check-in and check-out actions

## Current State

The repository is still a fresh Flutter scaffold. Architecture choices should support fast iteration while staying structured enough to evolve as the first feature slices grow.

The current attendance experience also has a defined visual system:

- brand name in product UI: `Presense`
- Material 3 theme with shared brand primitives under `lib/app/presentation/`
- platform launch assets and app icons aligned with the same brand mark
- light mode and dark mode both supported from the root `MaterialApp`

## Recommended Application Shape

Following a common Flutter clean architecture approach, the structure should stay feature-first, then split responsibilities by layer inside each feature:

```text
lib/
  app/
    app.dart
    router/
    theme/
  features/
    auth/
      presentation/
      domain/
      data/
    attendance/
      presentation/
      domain/
      data/
    profile/
      presentation/
      domain/
      data/
  shared/
    api/
    storage/
    widgets/
    utils/
```

The article reference reinforces the same idea through its diagrams: each feature owns its boundary, and responsibilities are split into `presentation`, `domain`, and `data` so they do not bleed into each other.

## Recommended Layers

Minimum structure per feature:

1. `presentation`
   Screens, widgets, bloc or notifier state, and UI-specific logic.
2. `domain`
   Entities, use cases, and repository contracts.
3. `data`
   Data sources, DTO models, and repository implementations.

Keep this pragmatic in the early stage. Do not force too many files or abstractions when a feature is still small, but keep the layer boundaries clear.

## Backend Integration

The mobile app should use these backend endpoints as the contract baseline:

- `GET /me`
- `GET /me/employee`
- `GET /me/shift-today`
- `GET /attendance-summary/today`
- `GET /attendance-policy`
- `GET /attendance-logs`
- `POST /attendance-logs/check-in`
- `POST /attendance-logs/check-out`

Backend documentation source of truth:

- `/Users/codebeast/Documents/src/artisancode/artisancode-backend-go/docs/mobile_attendance_v1.md`

## Initial Feature Flow

Recommended order:

1. app start checks stored auth state
2. user logs in
3. app requests `/me` and `/me/employee`
4. home screen requests `/attendance-summary/today`, `/me/shift-today`, and `/attendance-policy`
5. attendance action screen performs check-in or check-out
6. history screen loads `/attendance-logs`

## Early Implementation Principles

- UI should not call APIs directly without going through the data layer.
- Domain use cases should represent clear business actions.
- Domain entities should stay separate from backend response DTOs.
- Shared code should move into `lib/shared/` only when it is genuinely reused across features.
- Cross-feature and shared code references inside `lib/` should use `package:artisan_hr/...` imports so file moves do not deepen relative paths.
- Brand primitives that affect multiple screens should stay centralized. Current examples:
  - `lib/app/presentation/app_brand.dart` for shared brand mark, wordmark, and palette
  - `lib/app/presentation/app_theme.dart` for light and dark theme definitions
- Platform-facing branding is part of the mobile architecture surface, not an afterthought. When product branding changes, review:
  - Android launcher label and splash drawable
  - iOS display name, app icons, and launch assets
  - web manifest, title, favicon, and icons
- UX copy should be localized, concise, and layered. Primary status messaging belongs in one clear place instead of being repeated in multiple helper surfaces.

## Out Of Scope For The First Slice

- offline-first attendance sync
- biometric attendance proof
- complex background location logic
- admin or owner workflows
- broad global abstractions before real duplication appears
