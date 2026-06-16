.PHONY: help bootstrap clean format format-check analyze \
        gen watch-gen check-openapi-generator gen-api native-splash \
        run run-release build-apk build-appbundle build-ios

# On Windows, GNU Make runs recipes through cmd.exe by default, which breaks the
# Unix tooling these recipes rely on (grep / sed / cd && / forward-slash paths).
# Force Git Bash so the same recipes work on Windows and Unix alike.
# Requires bash.exe on PATH (run from Git Bash, or add Git's bin dir to PATH).
ifeq ($(OS),Windows_NT)
SHELL := bash.exe
endif

help:
	@echo "Available commands:"
	@echo ""
	@echo "  make bootstrap       - Install Flutter dependencies"
	@echo "  make clean           - Clean Flutter build files"
	@echo "  make format          - Format Dart code in lib/ and test/"
	@echo "  make format-check    - Check Dart formatting"
	@echo "  make analyze         - Run static analysis"
	@echo "  make gen             - Generate code with build_runner"
	@echo "  make watch-gen       - Watch and regenerate code with build_runner"
	@echo "  make gen-api         - Generate the typed API client from specs/swagger-mobile.json"
	@echo "  make native-splash   - Generate native splash assets"
	@echo "  make run             - Run the app"
	@echo "  make run-release     - Run the app in release mode"
	@echo "  make build-apk       - Build Android release APK"
	@echo "  make build-appbundle - Build Android release app bundle"
	@echo "  make build-ios       - Build iOS release app without codesign"

bootstrap:
	flutter pub get

clean:
	flutter clean

format:
	dart format lib test

format-check:
	dart format --set-exit-if-changed lib test

analyze:
	flutter analyze

gen:
	dart run build_runner build --delete-conflicting-outputs

watch-gen:
	dart run build_runner watch --delete-conflicting-outputs

# Check if openapi_generator_cli is installed, install if not.
# Use `dart pub global list` (not `command -v`) so the check doesn't depend on
# the pub-cache bin being on PATH — on Windows the executable is a `.bat`.
check-openapi-generator:
	@dart pub global list 2>/dev/null | grep -q '^openapi_generator_cli ' || { \
		echo "openapi_generator_cli not found. Installing..."; \
		dart pub global activate openapi_generator_cli; \
	}

# Generate the typed API client package from specs/swagger-mobile.json
# Usage: make gen-api
# Invoke via `dart pub global run` so it works without the pub-cache bin on PATH.
gen-api: check-openapi-generator
	dart pub global run openapi_generator_cli:main generate \
		-i specs/swagger-mobile.json \
		-g dart-dio \
		-o lib/generated/api \
		--additional-properties=pubName=api_client,nullableFields=true
# The dart-dio template ships sdk: '>=2.18.0 <4.0.0'. Pin it to this repo's
# SDK so the generated .g.dart parts compile at the same language version.
	@grep -q "sdk: '>=2.18.0 <4.0.0'" lib/generated/api/pubspec.yaml || { \
		echo "ERROR: expected SDK constraint not found in lib/generated/api/pubspec.yaml."; \
		echo "       dart-dio template default may have changed; update the sed below."; \
		exit 1; \
	}
	@sed -i.bak "s|sdk: '>=2.18.0 <4.0.0'|sdk: ^3.11.3|" lib/generated/api/pubspec.yaml
	@rm -f lib/generated/api/pubspec.yaml.bak
	cd lib/generated/api && dart pub get && dart run build_runner clean && dart run build_runner build
	@echo "API client generated into lib/generated/api (gitignored)"

native-splash:
	dart run flutter_native_splash:create

run:
	flutter run

run-release:
	flutter run --release

build-apk:
	flutter build apk --release

build-appbundle:
	flutter build appbundle --release

build-ios:
	flutter build ios --release --no-codesign
