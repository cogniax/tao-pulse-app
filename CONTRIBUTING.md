# Contributing to TaoPulse

Thanks for contributing to TaoPulse.

This project is developed in public. Contributions are welcome for the Flutter app, design improvements, bug fixes, docs, and developer tooling.

## Ways to Get Involved

Read the README first to understand TaoPulse and the main Bittensor concepts used in the product.

GitHub:
- Open [Issues](https://github.com/cogniax/tao-pulse-app/issues) for bugs, product feedback, or feature ideas.
- Use [Discussions](https://github.com/cogniax/tao-pulse-app/discussions) for roadmap and contributor-facing project discussion.
- Open [Pull Requests](https://github.com/cogniax/tao-pulse-app/pulls) for focused improvements that align with the project direction.
- GitHub is the canonical place for issues, pull requests, and accepted project decisions.

Element:
- Use Element for community chat, technical questions, design feedback, and contributor coordination.
- Room: https://matrix.to/#/#taopulse.app:matrix.org
- If an important decision starts in chat, summarize it back into GitHub.

## Development Setup

Install Flutter using the official guide:
https://docs.flutter.dev/get-started/install

After Flutter is installed, verify your environment:

```bash
flutter doctor
```

From the Flutter app directory, install dependencies:

```bash
cd tao-pulse-app
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

Run the app on a connected device or emulator:

```bash
flutter run
```

Useful Flutter commands:

```bash
flutter analyze
flutter build apk --release
flutter build appbundle --release
flutter build ios --release --no-codesign
```

You can also use the included Makefile for common workflows:

```bash
make bootstrap
make format
make format-check
make analyze
make run
make run-release
make build-apk
make build-appbundle
make build-ios
```

API docs for app-facing testing: https://icodex.space/docs

Notes:

- Use the Flutter app directory as the working directory for Flutter or `make` commands.
- Run `dart run build_runner build --delete-conflicting-outputs` after changing annotated router or Riverpod files, or use `make gen`.
- Make sure an emulator or physical device is available before running the app.
- If you change dependencies, run `make bootstrap` again so dependencies and generated files stay in sync.
- `make` is a convenience wrapper around common Flutter commands.


## Contribution Guidelines

- Discuss medium or large changes before implementation.
- Align changes with the README vision, roadmap, and product direction.
- Match the existing structure, naming, and architectural patterns.
- Keep UI changes clear, calm, and mobile-first.
- Avoid unrelated refactors in the same pull request.
- Prefer small, focused changes over broad mixed updates.
- Update documentation when behavior, setup, or contributor workflow changes.
- If a change requires API or mock data changes for the app, request it explicitly and explain why.
- AI coding tools are allowed, but contributors are responsible for guiding and reviewing the work carefully.
- Low-quality, unsupervised, or random AI-generated contributions may be rejected.

### Labels

Labels are used to make triage and roadmap alignment clearer.

- `needs-discussion`: the idea needs product or design discussion before implementation
- `accepted-design`: the direction is approved and ready for focused implementation
- `blocked`: the work is waiting on clarification or dependency changes
- `good-first-issue`: the issue is suitable for a first contribution
- `maintainer-only`: the work is sensitive, high-risk, or reserved for maintainers

### Pull Requests

When opening a pull request:

- link the issue or discussion that approved the work
- explain what changed
- explain why it changed
- include screenshots for UI changes when relevant
- list the testing or validation you ran

### Issues

For bug reports, include:

- expected behavior
- actual behavior
- reproduction steps
- screenshots or logs when relevant

For feature requests, include:

- the user problem
- the expected outcome
- why the change matters
