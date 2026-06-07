import 'package:flutter/material.dart';

import '../theme/theme.dart';

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    this.child,
    this.padding = const EdgeInsets.all(AppSpacing.xl),
    this.margin,
    this.width,
    this.alignment,
    this.backgroundColor = FigmaColors.neutralPrimary,
    this.borderColor = FigmaColors.neutralSecondary,
    this.borderRadius = AppRadius.xxl,
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget? child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final AlignmentGeometry? alignment;
  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: width,
      alignment: alignment,
      clipBehavior: clipBehavior,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );

    if (margin == null) {
      return card;
    }

    return Padding(padding: margin!, child: card);
  }
}
