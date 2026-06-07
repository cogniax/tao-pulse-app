import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../features/splash/views/splash_page.dart';
import '../features/onboarding/views/onboarding_page.dart';
import 'package:taopulse/features/home/views/home.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: const SplashRoute().location,
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

@TypedGoRoute<OnboardingRoute>(path: '/onboarding')
class OnboardingRoute extends GoRouteData with $OnboardingRoute {
  const OnboardingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const OnboardingPage();
  }
}

@TypedGoRoute<HomeRootRoute>(path: '/')
class HomeRootRoute extends GoRouteData with $HomeRootRoute {
  const HomeRootRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeRootPage();
  }
}
