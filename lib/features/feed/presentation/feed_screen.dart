import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/theme.dart';
import '../../../shared/widgets/app_top_bar.dart';
import '../../settings/data/settings_repository.dart';
import '../models/feed_item.dart';
import 'feed_filter.dart';
import 'feed_view_model.dart';
import 'widgets/feed_item_tile.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  static const _filters = <String>[
    'All',
    'Watchlist',
    'Subnets',
    'Stake',
    'Validators',
    'Governance',
    'AI Insights',
  ];

  String _selectedFilter = _filters.first;

  @override
  Widget build(BuildContext context) {
    final feedAsync = ref.watch(feedViewModelProvider);
    final watchlistNetuidsAsync = ref.watch(watchlistNetuidsProvider);
    final bottomDockClearance = 92.0 + MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 72,
        titleSpacing: AppSpacing.md,
        title: const AppTopBar(title: 'Live Feed'),
      ),
      body: Column(
        children: [
          Container(
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
                          right: filter == _filters.last ? 0 : AppSpacing.sm,
                        ),
                        child: _FeedFilterChip(
                          label: filter,
                          selected: filter == _selectedFilter,
                          onTap: () => setState(() {
                            _selectedFilter = filter;
                          }),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Expanded(
            child: feedAsync.when(
              data: (items) {
                final watchedNetuids = watchlistNetuidsAsync.maybeWhen(
                  data: (netuids) => netuids,
                  orElse: () => const <int>{},
                );
                final filteredItems = applyFeedFilter(
                  items,
                  _selectedFilter,
                  watchedNetuids: watchedNetuids,
                );
                return RefreshIndicator(
                  onRefresh: () => ref.refresh(feedViewModelProvider.future),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(4, 0, 4, bottomDockClearance),
                    itemBuilder: (context, index) =>
                        FeedItemTile(item: filteredItems[index]),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemCount: filteredItems.length,
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Center(child: Text('Failed to load feed: $error')),
            ),
          ),
        ],
      ),
    );
  }

}

class _FeedFilterChip extends StatelessWidget {
  const _FeedFilterChip({
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
        borderRadius: BorderRadius.circular(AppRadius.button),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.aiPurple.withValues(alpha: 0.96)
                : AppColors.surfaceSecondary,
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
