import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/theme.dart';
import '../../settings/data/settings_repository.dart';
import '../data/alerts_repository.dart';

class AlertSetupScreen extends ConsumerStatefulWidget {
  const AlertSetupScreen({super.key});

  @override
  ConsumerState<AlertSetupScreen> createState() => _AlertSetupScreenState();
}

class _AlertSetupScreenState extends ConsumerState<AlertSetupScreen> {
  Map<String, bool> _activityAlerts = {};
  Map<String, bool> _otherAlerts = {};
  String _subnetName = 'Subnet';
  int _netuid = 0;
  bool _watching = false;
  bool _initialized = false;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(alertSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
        title: Text(
          'Alert Setup',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 24),
        ),
      ),
      body: settingsAsync.when(
        data: (settings) {
          _hydrate(settings);
          return ListView(
            padding: const EdgeInsets.fromLTRB(4, AppSpacing.md, 4, 108),
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.hub_outlined,
                        color: AppColors.success,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _subnetName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Netuid: $_netuid',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        _watching ? 'Watching' : 'Paused',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.section),
              const _SetupSectionLabel(label: 'ACTIVITY ALERTS'),
              const SizedBox(height: AppSpacing.md),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  children: _activityAlerts.entries
                      .map(
                        (entry) => _SetupToggleTile(
                          title: entry.key,
                          subtitle: _subtitleForActivity(entry.key),
                          icon: _iconForActivity(entry.key),
                          color: _colorForActivity(entry.key),
                          value: entry.value,
                          onChanged: (value) {
                            setState(() {
                              _activityAlerts[entry.key] = value;
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.section),
              const _SetupSectionLabel(label: 'OTHER ALERTS'),
              const SizedBox(height: AppSpacing.md),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  children: _otherAlerts.entries
                      .map(
                        (entry) => _SetupToggleTile(
                          title: entry.key,
                          subtitle:
                              'Notify me about new releases and important updates.',
                          icon: Icons.code,
                          color: AppColors.textPrimary,
                          value: entry.value,
                          onChanged: (value) {
                            setState(() {
                              _otherAlerts[entry.key] = value;
                            });
                          },
                          showDivider: false,
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.section),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saving ? null : _saveSettings,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.lg,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                  ),
                  child: Text(_saving ? 'Saving...' : 'Save Alert Settings'),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Failed to load alert settings: $error')),
      ),
    );
  }

  void _hydrate(AlertSettings settings) {
    if (_initialized) {
      return;
    }
    _initialized = true;
    _activityAlerts = Map<String, bool>.from(settings.activityAlerts);
    _otherAlerts = Map<String, bool>.from(settings.otherAlerts);
    _subnetName = settings.subnetName;
    _netuid = settings.netuid;
    _watching = settings.watching;
  }

  Future<void> _saveSettings() async {
    setState(() => _saving = true);
    final repository = ref.read(alertsRepositoryProvider);

    try {
      await repository.updateAlertSettings(
        AlertSettings(
          subnetName: _subnetName,
          netuid: _netuid,
          watching: _watching,
          activityAlerts: _activityAlerts,
          otherAlerts: _otherAlerts,
        ),
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Alert settings saved.')));
      // Refresh every view derived from alert settings so the change is
      // reflected immediately instead of staying stale until an app restart.
      ref.invalidate(alertSettingsProvider);
      ref.invalidate(settingsDashboardProvider);
      ref.invalidate(alertsProvider);
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  String _subtitleForActivity(String title) {
    switch (title) {
      case 'Emission Changes':
        return 'Notify me when emissions increase or decrease significantly.';
      case 'Large Stake Movement':
        return 'Notify me when large amounts of TAO move in or out.';
      case 'Validator Changes':
        return 'Notify me when validators change weights or activity.';
      case 'Unusual Activity':
        return 'Notify me about unusual patterns or rapid changes.';
      case 'Risk Alerts':
        return 'Notify me about potential risks like deregistration or instability.';
      default:
        return '';
    }
  }

  IconData _iconForActivity(String title) {
    switch (title) {
      case 'Emission Changes':
        return Icons.bar_chart_rounded;
      case 'Large Stake Movement':
        return Icons.trending_up;
      case 'Validator Changes':
        return Icons.groups_outlined;
      case 'Unusual Activity':
        return Icons.shield_outlined;
      case 'Risk Alerts':
        return Icons.warning_amber_rounded;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _colorForActivity(String title) {
    switch (title) {
      case 'Emission Changes':
        return AppColors.aiPurple;
      case 'Large Stake Movement':
        return AppColors.success;
      case 'Validator Changes':
        return const Color(0xFFFFA055);
      case 'Unusual Activity':
        return AppColors.info;
      case 'Risk Alerts':
        return const Color(0xFFF4C542);
      default:
        return AppColors.textPrimary;
    }
  }
}

class _SetupSectionLabel extends StatelessWidget {
  const _SetupSectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: AppColors.textSecondary,
        letterSpacing: 0.7,
      ),
    );
  }
}

class _SetupToggleTile extends StatelessWidget {
  const _SetupToggleTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.borderSubtle))
            : null,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(AppRadius.smallCard),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 16),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
