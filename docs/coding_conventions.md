# Mobile HR Coding Conventions

## General

- Prefer clear and boring code over clever shortcuts.
- Keep files focused and avoid oversized widgets or service classes.
- Use English for code, comments, and identifiers.
- Keep comments short and only where they remove ambiguity.

## Dart Style

- Follow `flutter_lints` defaults unless the team documents a deliberate exception.
- Prefer immutable data where practical.
- Prefer small private helpers over deeply nested widget trees inside a single `build` method.
- Avoid premature generic abstractions when code is still used by only one feature.
- Inside `lib/`, prefer `package:artisan_hr/...` imports for app code instead of relative imports.
- Keep import groups ordered as `dart:`, then `package:`, then relative only when absolutely necessary.
- Remove unused imports as part of import refactors.

## Folder Conventions

- Group code by feature as the codebase grows.
- Inside a feature, prefer `presentation`, `domain`, and `data` boundaries once business flow starts becoming real.
- Keep shared utilities in `lib/shared/` only when they are genuinely used across features.
- Do not move platform files unless the task explicitly requires platform integration work.

## Networking

- Keep request models, response models, and API services explicit.
- Centralize auth header injection and error handling.
- Avoid scattering raw endpoint strings across screens and widgets.

## UI Conventions

- Every async screen should define loading, empty, error, and success states.
- Prefer reusable widgets for repeated status cards, list rows, and action buttons.
- Design for narrow mobile widths first, then let the layout expand gracefully.
- Use theme tokens instead of ad-hoc colors for component surfaces, text, borders, and modal backgrounds.
- New widgets should be reviewed in both light and dark mode before the task is considered complete.
- Avoid duplicating nearby user-facing copy, especially in hero sections, status cards, onboarding steps, and helper banners.
- If a component is visually tied to branding, prefer shared primitives from `lib/app/presentation/app_brand.dart` instead of re-declaring palette values locally.

## Testing Expectations

- Add unit or widget tests when business logic becomes non-trivial.
- Prefer focused tests around auth flow, attendance summary mapping, and check-in or check-out rules once those features exist.
- When theming or brand surfaces change, manually inspect contrast-sensitive areas such as hero buttons, bottom sheets, pickers, and navigation surfaces.

## Documentation

- If architecture or conventions shift, update `docs/` in the same change when practical.
- Keep examples aligned with the real folder structure.
