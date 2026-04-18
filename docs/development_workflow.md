# Mobile HR Development Workflow

## Daily Commands

Use the smallest command that is enough to validate the current change:

1. `flutter pub get`
2. `flutter analyze`
3. `flutter test`
4. `flutter run`

## Recommended Work Order

When building a new mobile feature:

1. confirm the backend contract and payload shape
2. define the API client and models
3. build the feature state, controller, or use case
4. implement the screen and its interaction states
5. verify loading, empty, error, and success behavior

## Attendance Foundation Priority

Recommended implementation order for the first real slice:

1. auth bootstrap and token persistence
2. current user bootstrap with `/me` and `/me/employee`
3. home dashboard with today summary and shift data
4. attendance action flow for check-in and check-out
5. attendance history list

## Documentation Workflow

- Update docs when conventions or architecture assumptions change.
- Update `agents.md` as well when the task changes workflow expectations, review rules, or agent operating instructions for future mobile work.
- Prefer small incremental documentation updates over large rewrites.
- Treat backend mobile attendance documentation as the API contract baseline until mobile-specific decisions start to diverge.
