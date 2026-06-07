import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/theme.dart';
import '../../../widgets/app_top_bar.dart';
import '../../../widgets/tab_page_scaffold.dart';
import '../view_models/subnets_notifier.dart';
import 'subnet_card.dart';
import 'subnet_filter_bar.dart';
import 'subnet_search_bar.dart';

class SubnetsPage extends ConsumerWidget {
  const SubnetsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subnetsAsync = ref.watch(subnetsProvider);

    return TabPageScaffold(
      appBar: const TopBar(title: 'Subnets'),
      child: subnetsAsync.when(
        data: (state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            SubnetSearchBar(onTap: () {}),
            const SizedBox(height: AppSpacing.xl),
            SubnetFilterBar(
              filters: state.filters,
              selectedFilter: state.selectedFilter,
              onSelected: ref.read(subnetsProvider.notifier).selectFilter,
              onSortPressed: ref.read(subnetsProvider.notifier).cycleSortOption,
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: RefreshIndicator(
                onRefresh: ref.read(subnetsProvider.notifier).refresh,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.bottomNavClearance,
                  ),
                  itemCount: state.visibleSubnets.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 9),
                  itemBuilder: (context, index) =>
                      SubnetCard(data: state.visibleSubnets[index]),
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Failed to load subnets.',
                  style: FigmaTypography.h7Semibold.copyWith(
                    color: FigmaColors.textNeutralPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '$error',
                  style: FigmaTypography.compactBodySmallRegular.copyWith(
                    color: FigmaColors.textNeutralInversePrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                OutlinedButton(
                  onPressed: () => ref.read(subnetsProvider.notifier).refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
