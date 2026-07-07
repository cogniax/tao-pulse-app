import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/theme.dart';
import '../../../widgets/app_top_bar.dart';
import '../../auth/view_models/auth_notifier.dart';
import '../view_models/settings_notifier.dart';
import '../widgets/grouped_utility_card.dart';
import '../widgets/logout_card.dart';
import '../widgets/primary_settings_card.dart';
import '../widgets/profile_summary_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(settingsProvider);

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
            ProfileSummaryCard(dashboard: dashboard),
            const SizedBox(height: AppSpacing.lg),
            PrimarySettingsCard(
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
            PrimarySettingsCard(
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
            PrimarySettingsCard(
              title: 'AI Preferences',
              description: 'Customize how Ask AI responds\nand behaves.',
              icon: Icons.auto_awesome_outlined,
              iconColor: AppColors.aiPurple,
              trailingText: _titleCase(dashboard.aiPreferenceLabel),
              trailingColor: AppColors.aiPurple,
              compact: true,
            ),
            const SizedBox(height: AppSpacing.md),
            PrimarySettingsCard(
              title: 'Appearance',
              description: 'Choose your preferred theme\nand app appearance.',
              icon: Icons.dark_mode_outlined,
              iconColor: const Color(0xFFE86BD8),
              trailingText: _titleCase(dashboard.appearanceLabel),
              trailingColor: AppColors.aiPurple,
              compact: true,
            ),
            const SizedBox(height: AppSpacing.lg),
            const GroupedUtilityCard(),
            const SizedBox(height: AppSpacing.lg),
            LogoutCard(onTap: () => ref.read(authProvider.notifier).logout()),
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
