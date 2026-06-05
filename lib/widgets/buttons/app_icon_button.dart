import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 38,
    this.padding = const EdgeInsets.all(10),
    this.backgroundColor = FigmaColors.pageBackground,
    this.borderColor = FigmaColors.iconNeutralInverseTertiary,
    this.iconColor = FigmaColors.iconNeutralPrimary,
    this.borderRadius = AppRadius.xl,
    this.borderWidth = 0.55,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final double size;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final double borderRadius;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Ink(
          width: size,
          height: size,
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
          ),
          child: FittedBox(
            fit: BoxFit.contain,
            child: IconTheme(
              data: IconThemeData(color: iconColor),
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}
