import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

/// Grouped list card for the secondary utility rows (Data & Privacy, Help &
/// Support, About).
class GroupedUtilityCard extends StatelessWidget {
  const GroupedUtilityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: const Column(
        children: [
          _UtilityRow(
            icon: Icons.verified_user_outlined,
            title: 'Data & Privacy',
          ),
          _UtilityRow(icon: Icons.help_outline, title: 'Help & Support'),
          _UtilityRow(
            icon: Icons.info_outline,
            title: 'About TaoPulse',
            trailingText: 'v1.0.0',
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _UtilityRow extends StatelessWidget {
  const _UtilityRow({
    required this.icon,
    required this.title,
    this.trailingText,
    this.showDivider = true,
  });

  final IconData icon;
  final String title;
  final String? trailingText;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.borderSubtle))
            : null,
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 22),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (trailingText != null)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: Text(
                trailingText!,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          const Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
            size: 24,
          ),
        ],
      ),
    );
  }
}
