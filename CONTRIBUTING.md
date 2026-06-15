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

Verify your environment, install dependencies, and run the app:

```bash
flutter doctor      # check your setup
make bootstrap      # install dependencies
make run            # run on a connected device or emulator
```

`make` wraps the common Flutter workflows used in day-to-day development:

```bash
make bootstrap                 # install dependencies
make run / make run-release    # run the app
make format / format-check     # format code / verify formatting
make analyze                   # static analysis
```

Notes:

- Make sure an emulator or physical device is available before running the app.
- If you change dependencies, run `make bootstrap` again.
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

### Code Guidelines

Before writing code, read the [Code Guidelines](.github/CODE_GUIDELINES.md) — they cover
the project architecture, state management, repository pattern, navigation,
theming, and naming conventions. New features should follow the patterns used by
existing ones.

### Labels

Labels are used to make triage and roadmap alignment clearer.

- `bug`: a defect in existing behavior
- `enhancement`: a new feature or improvement
- `needs-discussion`: the idea needs product or design discussion before implementation
- `accepted-design`: the direction is approved and ready for focused implementation
- `blocked`: the work is waiting on clarification or dependency changes
- `good-first-issue`: the issue is suitable for a first contribution
- `maintainer-only`: the work is sensitive, high-risk, or reserved for maintainers

### Pull Requests

Opening a pull request auto-fills the
[pull request template](.github/PULL_REQUEST_TEMPLATE.md). Fill in each section — link
the approving issue or discussion, explain what changed and why, and complete
the checklist before requesting review.

### Issues

Open issues using the templates — [Bug Report](.github/ISSUE_TEMPLATE/bug_report.yml) or
[Feature Request](.github/ISSUE_TEMPLATE/feature_request.yml). They prompt for the
details maintainers need to triage quickly.
