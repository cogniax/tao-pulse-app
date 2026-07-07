import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/models/auth_state.dart';
import '../features/auth/view_models/auth_notifier.dart';
import '../features/auth/views/login_page.dart';
import '../features/home/views/home.dart';
import '../features/subnets/models/subnet_info.dart';
import '../features/subnets/views/detail/subnet_detail.dart';
import '../features/splash/views/splash_page.dart';

part 'app_router.g.dart';

class _AuthStateRefreshListenable extends ChangeNotifier {
  _AuthStateRefreshListenable(this.ref) {
    ref.listen(authProvider, (_, _) => notifyListeners());
  }

  final Ref ref;
}

@riverpod
GoRouter appRouter(Ref ref) {
  final authRefresh = _AuthStateRefreshListenable(ref);
  ref.onDispose(authRefresh.dispose);

  return GoRouter(
    initialLocation: const SplashRoute().location,
    refreshListenable: authRefresh,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final authenticated = authState.value == const AuthState.authenticated();
      final checkingAuth = authState.isLoading && !authState.hasValue;
      final location = state.matchedLocation;

      // Screens reachable while signed out: the splash and the login screen.
      final publicRoute =
          location == const SplashRoute().location ||
          location == const LoginRoute().location;

      // Still resolving auth, or a signed-out user on a public screen: stay.
      if (checkingAuth || (publicRoute && !authenticated)) {
        return null;
      }
      // Signed-out user on a protected screen: send to login.
      if (!authenticated && !publicRoute) {
        return const LoginRoute().location;
      }
      // Signed-in user sitting on login: send home.
      if (authenticated && location == const LoginRoute().location) {
        return const HomeRootRoute().location;
      }
      return null;
    },
    routes: $appRoutes,
  );
}

@TypedGoRoute<SplashRoute>(path: '/splash')
class SplashRoute extends GoRouteData with $SplashRoute {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SplashPage();
  }
}

/// Sign-in screen, reached from the welcome landing's CTA.
@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
  }
}

@TypedShellRoute<AuthenticatedShellRoute>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<HomeRootRoute>(path: '/'),
    TypedGoRoute<SubnetDetailRoute>(path: '/subnets/:netuid'),
  ],
)
class AuthenticatedShellRoute extends ShellRouteData {
  const AuthenticatedShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return navigator;
  }
}

class HomeRootRoute extends GoRouteData with $HomeRootRoute {
  const HomeRootRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeRootPage();
  }
}

class SubnetDetailRoute extends GoRouteData with $SubnetDetailRoute {
  const SubnetDetailRoute({required this.netuid, required this.$extra});

  final int netuid;
  final SubnetInfo $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SubnetDetailPage(data: $extra);
  }
}
