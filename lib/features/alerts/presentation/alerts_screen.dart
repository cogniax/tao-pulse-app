import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/theme.dart';
import '../../../widgets/app_top_bar.dart';
import '../data/alerts_repository.dart';

class AlertsScreen extends ConsumerStatefulWidget {
  const AlertsScreen({super.key});

  @override
  ConsumerState<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends ConsumerState<AlertsScreen> {
  static const _filters = ['All', 'Unread', 'Critical', 'Watchlist'];
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final alertsAsync = ref.watch(alertsProvider(_selectedFilter));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 72,
        titleSpacing: AppSpacing.md,
        title: AppTopBar(
          title: 'Alert',
          showSearch: false,
          rightActions: [
            const AppTopBarAction(icon: Icons.search),
            AppTopBarAction(
              icon: Icons.settings_outlined,
              onPressed: () => context.push('/alerts/setup'),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              4,
              AppSpacing.md,
              4,
              AppSpacing.md,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters
                    .map(
                      (filter) => Padding(
                        padding: EdgeInsets.only(
                          right: filter == _filters.last ? 0 : AppSpacing.md,
                        ),
                        child: _AlertFilterChip(
                          label: filter,
                          selected: filter == _selectedFilter,
                          onTap: () => setState(() => _selectedFilter = filter),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Expanded(
            child: alertsAsync.when(
              data: (alerts) => ListView.separated(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 108),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const _SectionLabel(label: 'TODAY');
                  }
                  return _AlertCard(item: alerts[index - 1]);
                },
                separatorBuilder: (context, index) => SizedBox(
                  height: index == 0 ? AppSpacing.md : AppSpacing.sm,
                ),
                itemCount: alerts.length + 1,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Center(child: Text('Failed to load alerts: $error')),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertFilterChip extends StatelessWidget {
  const _AlertFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.aiPurple.withValues(alpha: 0.95)
                : AppColors.surfaceSecondary,
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: AppColors.textSecondary,
        letterSpacing: 0.6,
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.item});

  final AlertItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _colorForSeverity(item.severity);
    final icon = _iconForCategory(item.category);
    final severityStyle = _severityStyle(item.severity);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(AppRadius.smallCard),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.category,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: severityStyle.$2,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        item.severity.toUpperCase(),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: severityStyle.$1,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      item.timeAgo,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  item.title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 20,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  item.description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    FilledButton.tonal(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.aiPurple.withValues(
                          alpha: 0.18,
                        ),
                        foregroundColor: AppColors.aiPurple,
                      ),
                      child: const Text('Ask AI'),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    FilledButton.tonal(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.06),
                        foregroundColor: AppColors.textPrimary,
                      ),
                      child: Text(item.primaryAction),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForCategory(String category) {
    switch (category) {
      case 'Large Stake Movement':
        return Icons.savings_outlined;
      case 'Subnet Emission Spike':
        return Icons.bar_chart_rounded;
      case 'Validator Rotation':
        return Icons.groups_outlined;
      case 'Deregistration Risk':
        return Icons.shield_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _colorForSeverity(String severity) {
    switch (severity) {
      case 'Critical':
        return AppColors.critical;
      case 'High':
        return AppColors.warning;
      case 'Medium':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  (Color, Color) _severityStyle(String severity) {
    switch (severity) {
      case 'Critical':
        return (const Color(0xFFFF7474), const Color(0x33EF4444));
      case 'High':
        return (const Color(0xFFFFB347), const Color(0x33F59E0B));
      case 'Medium':
        return (const Color(0xFF67B6FF), const Color(0x333B82F6));
      default:
        return (AppColors.textSecondary, Colors.white10);
    }
  }
}
