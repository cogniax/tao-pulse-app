# TaoPulse Code Guidelines

This document describes how the TaoPulse Flutter app is structured and the
patterns contributors are expected to follow. It complements
[CONTRIBUTING.md](../CONTRIBUTING.md), which covers the contribution process, and
[`analysis_options.yaml`](../analysis_options.yaml), which enforces formatting
and lint rules automatically.

The goal is consistency: a new feature should look like the existing ones, so
the codebase stays predictable as it grows.

## Tech Stack

- **State management:** [Riverpod](https://riverpod.dev) (`flutter_riverpod`)
  with code generation (`riverpod_annotation` + `riverpod_generator`).
- **Navigation:** [`go_router`](https://pub.dev/packages/go_router) with typed
  routes (`go_router_builder`).
- **Networking:** [`dio`](https://pub.dev/packages/dio), wrapped by a single
  `ApiClient`.
- **Code generation:** `build_runner`. Run `make gen` once, or `make watch-gen`
  while developing, after editing any annotated class (`@riverpod`,
  `@TypedGoRoute`, etc.). Generated `*.g.dart` files are committed.

## Project Structure

The app is **feature-first**: each user-facing area lives under
`lib/features/<feature>/` and owns its data, state, and UI. Cross-cutting code
lives in shared top-level folders.

```
lib/
  api/          # ApiClient (dio) and the apiClientProvider
  app/          # app.dart (root widget) and app_router.dart (routes)
  constants/    # app-wide constant values
  theme/        # colors, spacing, radius, typography, gradients, shadows
  widgets/      # shared, feature-agnostic widgets (e.g. buttons/)
  features/
    <feature>/
      data/         # repositories: abstract interface + Api*/Mock* impls + mappers
      models/       # immutable domain models for the feature
      view_models/  # Riverpod notifiers (*Notifier) + immutable *ViewState
      views/        # widgets and screens; group large features (list/, detail/)
```

> **Canonical layout.** Use `data/`, `models/`, `view_models/`, `views/`. Some
> existing features still carry legacy folders (`presentation/`,
> `repositories/`) from before this was standardized — prefer the canonical
> layout for new code, and consolidate stragglers when you are already working
> in that file (not as an unrelated refactor — see CONTRIBUTING).

## Layering & Data Flow

Data flows in one direction:

```
View (widget)  →  ViewModel (Notifier)  →  Repository  →  ApiClient / Mock
     ↑                    │
     └──── ViewState ─────┘
```

- **Views** read state and render it. They contain no business logic.
- **ViewModels** (`*Notifier`) own state, call repositories, and expose intent
  methods (`refresh`, `selectFilter`, …).
- **Repositories** abstract data access behind an interface so the app can swap
  between live API and mock implementations.
- **ApiClient** is the only place that talks to `dio`.

### View models

Use generated Riverpod notifiers. Hold state in a dedicated immutable
`*ViewState` class and use `AsyncValue` for load/error handling.

```dart
@riverpod
class SubnetsNotifier extends _$SubnetsNotifier {
  @override
  Future<SubnetsViewState> build() async => _loadState();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadState);
  }

  void selectFilter(SubnetFilterType filter) {
    final current = state.value;
    if (current == null || current.selectedFilter == filter) return;
    state = AsyncData(current.copyWith(selectedFilter: filter));
  }
}
```

- Wrap async work in `AsyncValue.guard` so errors land in the `AsyncError`
  state instead of throwing.
- Keep `*ViewState` immutable: `const` constructor, `final` fields, a
  `copyWith`. Put **derived data** (filtering, sorting) in getters on the view
  state, not in widgets — see `visibleSubnets` in `subnets_view_state.dart`.

### Repositories

Define an abstract interface in `data/`, then provide concrete `Api*` and
`Mock*` implementations.

```dart
abstract class FeedRepository {
  Future<List<FeedItem>> getFeed();
}

class ApiFeedRepository implements FeedRepository {
  ApiFeedRepository(this._apiClient);
  final ApiClient _apiClient;

  @override
  Future<List<FeedItem>> getFeed() async {
    final data = await _apiClient.get('/api/v1/feed');
    return (data['items'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(FeedItemMapper.fromJson)
        .toList();
  }
}
```

- Expose repositories through a Riverpod provider; view models obtain them with
  `ref.read(...)`.
- Parse JSON in a `*Mapper.fromJson` and default every field defensively
  (`json['title'] as String? ?? ''`) so a malformed payload can't crash the UI.
- If a feature needs new API or mock data, request it explicitly and explain why
  (see CONTRIBUTING).

### Networking

All HTTP goes through `ApiClient` (`lib/api/api_client.dart`), obtained via
`apiClientProvider`. Do not create `dio` instances elsewhere.

- The API wraps payloads in a `data` envelope, unwrapped centrally by the
  client — repositories receive the inner map.
- The base URL is resolved from the `API_BASE_URL` dart-define with
  platform-aware local fallbacks. Never hardcode hosts in feature code.

## Navigation

Routes are declared as typed `go_router` routes in `lib/app/app_router.dart`.

```dart
@TypedGoRoute<SubnetDetailRoute>(path: '/subnets/:netuid')
class SubnetDetailRoute extends GoRouteData with $SubnetDetailRoute {
  const SubnetDetailRoute({required this.netuid, required this.$extra});
  final int netuid;
  final SubnetInfo $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SubnetDetailPage(data: $extra);
}
```

- Add new screens by declaring a `@TypedGoRoute` class and running `make gen`.
- Navigate with the generated route objects (e.g. `const SplashRoute().go(...)`)
  rather than raw path strings.

## Theming & UI

- Use the design tokens in `lib/theme/` — `AppColors`, `AppSpacing`,
  `AppRadius`, `AppTypography`, `AppGradients`, `AppShadows`. **Do not hardcode**
  colors, spacing, or font sizes.
- Keep widgets small and composable; extract reusable pieces into the feature's
  `views/` (or `lib/widgets/` if feature-agnostic).
- Honor the product feel: clear, calm, mobile-first — not ad-like or
  popup-heavy (see the README vision).

## Naming Conventions

| Kind            | Pattern                    | Example                   |
| --------------- | -------------------------- | ------------------------- |
| Screen / page   | `*Page` / `*Screen`        | `SubnetsPage`             |
| View model      | `*Notifier`                | `SubnetsNotifier`         |
| View state      | `*ViewState`               | `SubnetsViewState`        |
| Repository      | `*Repository` + `Api*`/`Mock*` | `ApiFeedRepository`   |
| JSON mapper     | `*Mapper`                  | `FeedItemMapper`          |
| Route           | `*Route`                   | `SubnetDetailRoute`       |
| Files           | `snake_case.dart`          | `subnets_notifier.dart`   |

## Before You Open a PR

- `make format` — apply the formatter.
- `make analyze` — pass static analysis with no new warnings.
- `make gen` — if you changed any annotated class, regenerate and commit the
  `*.g.dart` files.
- Use `// ignore:` only with a clear, justified reason.
