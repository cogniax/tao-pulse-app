import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

/// The "TaoPulse" wordmark. Starts centered — matching the native splash — and
/// glides to the top, driven by [alignment].
class SplashWordmark extends StatelessWidget {
  const SplashWordmark({required this.alignment, super.key});

  final Animation<Alignment> alignment;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: alignment,
      builder: (context, child) =>
          Align(alignment: alignment.value, child: child),
      child: Text(
        'TaoPulse',
        textAlign: TextAlign.center,
        style: FigmaTypography.h2Bold.copyWith(color: FigmaColors.brandPrimary),
      ),
    );
  }
}
