import 'package:flutter/material.dart';

import '../theme/theme.dart';

class TabPageScaffold extends StatelessWidget {
  const TabPageScaffold({
    super.key,
    this.appBar,
    required this.child,
    this.backgroundColor = FigmaColors.pageBackground,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 0),
  });

  final PreferredSizeWidget? appBar;
  final Widget child;
  final Color backgroundColor;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Padding(padding: contentPadding, child: child),
      ),
    );
  }
}
