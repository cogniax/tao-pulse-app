import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

/// A tappable settings row card (Watching, Notifications, AI Preferences,
/// Appearance) with a leading icon, title/description and a trailing value or
/// avatar strip.
class PrimarySettingsCard extends StatelessWidget {
  const PrimarySettingsCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    this.trailingText,
    this.trailingColor,
    this.avatarColors = const [],
    this.compact = false,
    super.key,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final String? trailingText;
  final Color? trailingColor;
  final List<Color> avatarColors;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: compact ? 44 : 56,
            height: compact ? 44 : 56,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(AppRadius.smallCard),
            ),
            child: Icon(icon, color: iconColor, size: compact ? 22 : 28),
          ),
          SizedBox(width: compact ? AppSpacing.md : AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: compact ? 18 : 20,
                  ),
                ),
                SizedBox(height: compact ? AppSpacing.xs : AppSpacing.sm),
                Text(
                  description,
                  maxLines: compact ? 2 : null,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.3,
                    fontSize: compact ? 12 : null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          _SettingsCardTrailing(
            text: trailingText,
            textColor: trailingColor,
            avatarColors: avatarColors,
            compact: compact,
          ),
          SizedBox(width: compact ? AppSpacing.sm : AppSpacing.md),
          Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
            size: compact ? 22 : 28,
          ),
        ],
      ),
    );
  }
}

class _SettingsCardTrailing extends StatelessWidget {
  const _SettingsCardTrailing({
    this.text,
    this.textColor,
    this.avatarColors = const [],
    this.compact = false,
  });

  final String? text;
  final Color? textColor;
  final List<Color> avatarColors;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (avatarColors.isNotEmpty) {
      final overlapCount = avatarColors.length;
      final avatarSize = compact ? 22.0 : 34.0;
      final overlapOffset = compact ? 14.0 : 28.0;
      final avatarStripWidth =
          avatarSize + (overlapOffset * (overlapCount - 1));

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: avatarStripWidth,
            height: avatarSize,
            child: Stack(
              children: [
                for (var i = 0; i < avatarColors.length; i++)
                  Positioned(
                    left: overlapOffset * i,
                    child: Container(
                      width: avatarSize,
                      height: avatarSize,
                      decoration: BoxDecoration(
                        color: avatarColors[i].withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.surfaceCard,
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: compact ? AppSpacing.xs : 0),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? AppSpacing.xs : AppSpacing.md,
              vertical: compact ? 4 : AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              text ?? '',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textPrimary,
                fontSize: compact ? 11 : null,
              ),
            ),
          ),
        ],
      );
    }

    if (text == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: (textColor ?? AppColors.textPrimary).withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        text!,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: textColor ?? AppColors.textPrimary,
        ),
      ),
    );
  }
}
