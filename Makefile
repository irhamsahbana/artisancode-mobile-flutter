ifneq (,$(wildcard .env.local))
include .env.local
export
endif

FLUTTER ?= flutter
API_BASE_URL ?= http://127.0.0.1:3939
ANDROID_API_BASE_URL ?= http://10.0.2.2:3939
IOS_DEVICE ?= ios

.PHONY: help pub-get analyze test check clean doctor devices run run-macos run-chrome run-android-emulator run-ios-profile run-ios-release

help:
	@printf "%s\n" \
		"Available targets:" \
		"  make pub-get               Install Flutter dependencies" \
		"  make analyze               Run static analysis" \
		"  make test                  Run widget and unit tests" \
		"  make check                 Run analyze and test" \
		"  make doctor                Show Flutter environment diagnostics" \
		"  make devices               List available Flutter devices" \
		"  make run                   Run app with API_BASE_URL=$(API_BASE_URL)" \
		"  make run-ios-profile       Run iPhone build in profile mode on IOS_DEVICE=$(IOS_DEVICE)" \
		"  make run-ios-release       Run iPhone build in release mode on IOS_DEVICE=$(IOS_DEVICE)" \
		"  make run-macos             Run macOS app with API_BASE_URL=$(API_BASE_URL)" \
		"  make run-chrome            Run web app with API_BASE_URL=$(API_BASE_URL)" \
		"  make run-android-emulator  Run Android app with API_BASE_URL=$(ANDROID_API_BASE_URL)" \
		"  make clean                 Remove generated build artifacts" \
		"" \
		"Notes:" \
		"  Override the Flutter binary if it is not in PATH:" \
		"    make analyze FLUTTER=/Users/x/flutter/bin/flutter" \
		"  Override the iPhone target when needed:" \
		"    make run-ios-release IOS_DEVICE=<your-device-id>" \
		"  Override API base URL when needed:" \
		"    make run API_BASE_URL=http://192.168.1.10:3939"

pub-get:
	$(FLUTTER) pub get

analyze:
	$(FLUTTER) analyze

test:
	$(FLUTTER) test

check: analyze test

doctor:
	$(FLUTTER) doctor -v

devices:
	$(FLUTTER) devices

run:
	$(FLUTTER) run --dart-define=API_BASE_URL=$(API_BASE_URL)

run-ios-profile:
	$(FLUTTER) run -d $(IOS_DEVICE) --profile --dart-define=API_BASE_URL=$(API_BASE_URL)

run-ios-release:
	$(FLUTTER) run -d $(IOS_DEVICE) --release --dart-define=API_BASE_URL=$(API_BASE_URL)

run-macos:
	$(FLUTTER) run -d macos --dart-define=API_BASE_URL=$(API_BASE_URL)

run-chrome:
	$(FLUTTER) run -d chrome --dart-define=API_BASE_URL=$(API_BASE_URL)

run-android-emulator:
	$(FLUTTER) run -d android --dart-define=API_BASE_URL=$(ANDROID_API_BASE_URL)

clean:
	$(FLUTTER) clean
