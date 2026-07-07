import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../models/settings_dashboard.dart';

/// Header card: the user's avatar, name, edit action and the three headline
/// stats (watching / alerts / AI conversations).
class ProfileSummaryCard extends StatelessWidget {
  const ProfileSummaryCard({required this.dashboard, super.key});

  final SettingsDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    final stats = [
      _SettingsStat(
        value: '${dashboard.watchingEntities}',
        label: 'Watching\nentities',
        icon: Icons.star_rounded,
        color: AppColors.aiPurple,
      ),
      _SettingsStat(
        value: '${dashboard.alertsEnabled}',
        label: 'Alerts\nenabled',
        icon: Icons.notifications_rounded,
        color: AppColors.info,
      ),
      _SettingsStat(
        value: '${dashboard.aiConversationsThisMonth}',
        label: 'AI conversations\nthis month',
        icon: Icons.chat_bubble_rounded,
        color: AppColors.success,
      ),
    ];

    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(AppRadius.modal),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF36205F), Color(0xFF1E2232)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.aiPurple.withValues(alpha: 0.9),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    dashboard.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Text(
                  dashboard.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineMedium?.copyWith(fontSize: 22),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              FilledButton.tonal(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.06),
                  foregroundColor: AppColors.textPrimary,
                  minimumSize: const Size(0, 36),
                ),
                child: const Text('Edit Profile'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Row(
              children: stats
                  .map(
                    (stat) => Expanded(
                      child: _StatTile(
                        stat: stat,
                        showDivider: stat != stats.last,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.stat, required this.showDivider});

  final _SettingsStat stat;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(right: BorderSide(color: AppColors.borderSubtle))
            : null,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: stat.color.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(stat.icon, color: stat.color, size: 18),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat.value,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  stat.label,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsStat {
  const _SettingsStat({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;
}
