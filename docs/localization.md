# Localization

## Current State

Mobile multi-language is already implemented for Indonesian (`id`) and English (`en`).

Main building blocks:

- `lib/l10n/app_en.arb`
- `lib/l10n/app_id.arb`
- `l10n.yaml`
- generated output in `lib/l10n/generated/`
- `lib/shared/localization/l10n.dart`
- `lib/app/app_controller.dart`
- `lib/shared/core/api/api_client.dart`
- `lib/app/presentation/app_view.dart`

## How It Works

- Flutter gen-l10n generates `AppLocalizations`.
- `AppView` wires `supportedLocales` and localization delegates into `MaterialApp`.
- `AppController` stores current language code and exposes `Locale`.
- `AppController.setLanguage(...)` updates app locale and also updates `ApiClient` language.
- Widgets read copy via `context.l10n`.
- `ApiClient` sends `Accept-Language: id|en` so backend errors/messages match selected app language.

## Supported Locales

- `id` default
- `en` supported

## Rules

- For new UI copy, update both `app_en.arb` and `app_id.arb`.
- Read localized strings through `context.l10n`; do not hardcode user-facing copy when a localization entry should exist.
- Do not edit files under `lib/l10n/generated/` manually.
- If you change ARB keys, regenerate localization output with normal Flutter tooling as part of the task.
- Keep app locale handling centralized in `AppController`.
- Do not send language headers manually from repositories or feature code; `ApiClient` already does this.

## Message Handling

The app uses two message shapes:

- keyed app-owned messages through `AppMessageKey`
- raw backend messages through `AppMessage.raw(...)`

`resolveMessage(...)` in `lib/shared/localization/l10n.dart` handles keyed app messages.

Backend-provided messages are shown as-is, which is correct because backend already localizes them based on `Accept-Language`.

## Practical Check

If mobile language behavior looks wrong:

1. verify selected language changed in `AppController`
2. verify widget text uses `context.l10n`
3. verify ARB files contain both locale entries
4. verify `ApiClient` still sends `Accept-Language`
5. verify backend response is localized for the same language
