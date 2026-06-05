import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class OutlinedTextButton extends StatelessWidget {
  const OutlinedTextButton({
    super.key,
    required this.label,
    this.selected = false,
    this.onPressed,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.xl,
      vertical: 10,
    ),
    this.backgroundColor = FigmaColors.neutralPrimary,
    this.selectedBackgroundColor = FigmaColors.neutralInverseSecondary,
    this.borderColor = FigmaColors.iconNeutralInverseTertiary,
    this.textColor = FigmaColors.textNeutralPrimary,
    this.selectedTextColor = FigmaColors.neutralPrimary,
    this.borderRadius = AppRadius.xl,
  });

  final String label;
  final bool selected;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color selectedBackgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color selectedTextColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final fillColor = selected ? selectedBackgroundColor : backgroundColor;
    final foregroundColor = selected ? selectedTextColor : textColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Ink(
          padding: padding,
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor),
          ),
          child: Text(
            label,
            style: FigmaTypography.h8Medium.copyWith(color: foregroundColor),
          ),
        ),
      ),
    );
  }
}
