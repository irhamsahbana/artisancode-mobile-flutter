# artisan_hr

Employee mobile app for the Artisancode ecosystem. The first product slice focuses on attendance: login, employee context bootstrap, today summary, attendance history, and check-in or check-out flows backed by the Go API.

## Project Status

This project now includes the first functional foundation of the employee app:

- login screen with configurable API base URL
- authenticated home dashboard
- today attendance summary
- shift and policy snapshot cards
- attendance check-in and check-out actions
- attendance history list

The app currently keeps auth tokens in memory only. Persistent secure storage is still a follow-up task.

## Key Docs

- [agents.md](./agents.md)
- [docs/architecture.md](./docs/architecture.md)
- [docs/tech_stack.md](./docs/tech_stack.md)
- [docs/coding_conventions.md](./docs/coding_conventions.md)
- [docs/development_workflow.md](./docs/development_workflow.md)

## Backend Contract Reference

The current mobile attendance backend contract is documented in:

- `/Users/codebeast/Documents/src/artisancode/artisancode-backend-go/docs/mobile_attendance_v1.md`

## Useful Commands

```bash
flutter pub get
flutter analyze
flutter test
flutter run
make run-ios-simulator
```

## Running Against Local Backend

You can point the app to a backend URL in two ways:

1. Enter the base URL directly on the login screen.
2. Provide a default at launch time:

```bash
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:3939
```

For Android emulators, you may need `http://10.0.2.2:3939` instead of `127.0.0.1`.

To open Apple's Simulator and run on a default iPhone simulator in one step:

```bash
make run-ios-simulator
```

To target a different simulator:

```bash
make run-ios-simulator IOS_SIMULATOR="iPhone 16 Pro"
```
