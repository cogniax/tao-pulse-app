import 'package:flutter/material.dart';

import '../theme/theme.dart';

class TabPageScaffold extends StatelessWidget {
  const TabPageScaffold({
    super.key,
    this.appBar,
    required this.child,
    this.backgroundColor = FigmaColors.pageBackground,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
    ),
    this.bottomNavBarHeight = AppSpacing.bottomNavBarHeight,
  });

  final PreferredSizeWidget? appBar;
  final Widget child;
  final Color backgroundColor;
  final EdgeInsetsGeometry contentPadding;
  final double bottomNavBarHeight;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: contentPadding.add(
            EdgeInsets.only(bottom: bottomNavBarHeight + bottomInset),
          ),
          child: child,
        ),
      ),
    );
  }
}
