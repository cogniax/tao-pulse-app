import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/theme.dart';
import '../../../widgets/app_top_bar.dart';
import '../data/settings_repository.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(settingsDashboardProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 72,
        titleSpacing: AppSpacing.md,
        title: const AppTopBar(title: 'Settings', showSearch: false),
      ),
      body: dashboardAsync.when(
        data: (dashboard) => ListView(
          padding: const EdgeInsets.fromLTRB(4, AppSpacing.md, 4, 108),
          children: [
            _ProfileSummaryCard(dashboard: dashboard),
            const SizedBox(height: AppSpacing.lg),
            _PrimarySettingsCard(
              title: 'Watching',
              description:
                  'Manage watched subnets, validators,\nwallets and miners.',
              icon: Icons.visibility_outlined,
              iconColor: AppColors.aiPurple,
              trailingText: dashboard.watchingCountLabel,
              compact: true,
              avatarColors: const [
                AppColors.success,
                AppColors.info,
                AppColors.aiPurple,
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _PrimarySettingsCard(
              title: 'Notification Settings',
              description:
                  'Control what alerts you get\nand how you receive them.',
              icon: Icons.notifications_none_rounded,
              iconColor: AppColors.success,
              trailingText: dashboard.notificationSummary,
              trailingColor: AppColors.success,
              compact: true,
            ),
            const SizedBox(height: AppSpacing.md),
            _PrimarySettingsCard(
              title: 'AI Preferences',
              description: 'Customize how Ask AI responds\nand behaves.',
              icon: Icons.auto_awesome_outlined,
              iconColor: AppColors.aiPurple,
              trailingText: _titleCase(dashboard.aiPreferenceLabel),
              trailingColor: AppColors.aiPurple,
              compact: true,
            ),
            const SizedBox(height: AppSpacing.md),
            _PrimarySettingsCard(
              title: 'Appearance',
              description: 'Choose your preferred theme\nand app appearance.',
              icon: Icons.dark_mode_outlined,
              iconColor: const Color(0xFFE86BD8),
              trailingText: _titleCase(dashboard.appearanceLabel),
              trailingColor: AppColors.aiPurple,
              compact: true,
            ),
            const SizedBox(height: AppSpacing.lg),
            const _GroupedUtilityCard(),
            const SizedBox(height: AppSpacing.lg),
            const _LogoutCard(),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Failed to load settings: $error')),
      ),
    );
  }

  String _titleCase(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value[0].toUpperCase() + value.substring(1);
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({required this.dashboard});

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

class _PrimarySettingsCard extends StatelessWidget {
  const _PrimarySettingsCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    this.trailingText,
    this.trailingColor,
    this.avatarColors = const [],
    this.compact = false,
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

class _GroupedUtilityCard extends StatelessWidget {
  const _GroupedUtilityCard();

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

class _LogoutCard extends StatelessWidget {
  const _LogoutCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.critical.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            child: const Icon(
              Icons.logout_rounded,
              color: AppColors.critical,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'Log Out',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.critical,
                fontSize: 18,
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
