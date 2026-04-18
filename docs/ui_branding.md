# UI Branding And UX Rules

## Current Product Direction

The employee attendance app uses the `Presense` product identity.

This direction came out of the current mobile redesign work and should be treated as the working visual source of truth until the team changes it again.

Core decisions:

- product name shown in the app: `Presense`
- visual identity: deep teal + mint
- icon concept: concentric presence rings with a central attendance point
- tone of voice: clear, calm, direct, and low-friction

## Implementation Source Of Truth

Primary implementation files:

- `lib/app/presentation/app_brand.dart`
- `lib/app/presentation/app_theme.dart`
- `lib/features/auth/presentation/screens/login_screen.dart`
- `lib/features/auth/presentation/screens/onboarding_screen.dart`
- `lib/features/attendance/presentation/screens/attendance_home_screen.dart`
- `lib/features/attendance/presentation/screens/attendance_history_screen.dart`

Brand assets:

- `assets/branding/presense_app_icon.svg`
- `assets/branding/presense_launch_mark.svg`

Platform outputs already aligned to this direction:

- Android launcher icons and splash background
- iOS app icons and launch image
- web favicon, manifest icons, and title metadata

## Theme Rules

- Support both light mode and dark mode through the root app theme.
- New surfaces must be checked in both modes before they are considered done.
- Do not assume a light background. Any new component should derive colors from `Theme.of(context).colorScheme`.
- Avoid hardcoded text colors on reusable widgets unless the widget is intentionally locked to a branded surface and the contrast is known to be safe.

## Contrast Rules

- Prioritize readable text over subtle styling.
- Buttons on colored hero panels must keep strong foreground or border contrast in both enabled and disabled states.
- Helper text on tinted cards must still be readable without squinting.
- Bottom sheets, pickers, and modal surfaces must follow the active theme; do not leave them bright white in dark mode.
- If a design choice creates doubt between elegance and readability, choose readability.

## Copy Rules

- Do not repeat the same idea in multiple nearby components.
- Status cards should carry the main message once.
- Secondary chips, helper text, and subtitles should add context, not restate the same sentence.
- Prefer practical employee-facing wording over system-sounding copy.
- Keep Indonesian and English copy aligned in meaning, not necessarily word-for-word.

## Attendance Screen Notes

- The hero card is the primary focus on the home screen.
- `Check-in` and `Check-out` actions must stay readable on top of the branded gradient.
- If one action is unavailable, the disabled state should still remain visibly intentional rather than disappearing into the background.
- The `Status hari ini` block should not be followed by duplicate blocked-reason text unless that extra message is operationally necessary.

## Onboarding And Auth Notes

- Onboarding should introduce the product clearly without repeated badge or headline copy.
- Login should explain permission timing once in a concise info block.
- Decorative gradients are acceptable, but text contrast must remain stronger than the decoration.

## When Updating This Document

Update this file when any of the following changes:

- brand name
- color system
- icon mark or splash direction
- light or dark theme behavior
- UX wording principles
- repeated pain points discovered in design review or screenshots
