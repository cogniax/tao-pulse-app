import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppPageTransitions {
  const AppPageTransitions._();

  static const theme = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
      TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
      TargetPlatform.fuchsia: CupertinoPageTransitionsBuilder(),
    },
  );
}

class HorizontalParallaxPageTransitionsBuilder extends PageTransitionsBuilder {
  const HorizontalParallaxPageTransitionsBuilder();

  static const Duration _transitionDuration = Duration(milliseconds: 320);
  static const Duration _reverseTransitionDuration = Duration(
    milliseconds: 280,
  );

  @override
  Duration get transitionDuration => _transitionDuration;

  @override
  Duration get reverseTransitionDuration => _reverseTransitionDuration;

  @override
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext? context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final primaryAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubicEmphasized,
      reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
    );
    final secondaryPageAnimation = CurvedAnimation(
      parent: secondaryAnimation,
      curve: Curves.easeInOutCubicEmphasized,
      reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
    );

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(primaryAnimation),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.025, 0),
        ).animate(secondaryPageAnimation),
        child: child,
      ),
    );
  }
}
