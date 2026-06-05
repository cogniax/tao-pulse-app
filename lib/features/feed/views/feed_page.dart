import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../widgets/app_top_bar.dart';
import '../../../widgets/buttons/search_button.dart';
import '../../../widgets/tab_page_scaffold.dart';
import 'feed_card.dart';
import 'filter_view.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  static const _filters = <String>[
    'All',
    'Watchlist',
    'Subnets',
    'Stake',
    'Validation',
  ];

  static const _feedCards = <FeedCardData>[
    FeedCardData(
      title: 'Subnet 15 emissions increased by 12%',
      subtitle: 'Stake Moment',
      description:
          'Emissions increased from 41.2 TAO/hr to 46.1 TAO/hr Versus the previous 24 hours',
      indicator: 'Large stake inflow indication',
      badge: 'Impact badge',
      tags: ['Tag #1', 'Tag #2', 'Tag #3'],
      filters: ['Watchlist', 'Stake'],
    ),
    FeedCardData(
      title: 'Validator 42 reached a new trust score high',
      subtitle: 'Validation Event',
      description:
          'Trust score moved from 0.71 to 0.79 after the latest performance interval closed',
      indicator: 'Consensus confidence continued to improve',
      badge: 'Confidence badge',
      tags: ['Validator', 'Trust', 'Score'],
      filters: ['Validation'],
      icon: Icons.verified_outlined,
    ),
    FeedCardData(
      title: 'Subnet 9 volume momentum held above weekly range',
      subtitle: 'Subnet Activity',
      description:
          'Subnet buy pressure remained elevated throughout the cycle with no cooldown into reset',
      indicator: 'Momentum signal remains above baseline',
      badge: 'Momentum badge',
      tags: ['Subnet', 'Flow', 'Volume'],
      filters: ['Subnets'],
      icon: Icons.stacked_line_chart_rounded,
    ),
  ];

  String _selectedFilter = _filters.first;

  List<FeedCardData> get _visibleCards {
    if (_selectedFilter == _filters.first) {
      return _feedCards;
    }

    return _feedCards
        .where((card) => card.filters.contains(_selectedFilter))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return TabPageScaffold(
      appBar: const TopBar(
        left: _FeedTopBarIcon(),
        right: SearchButton(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),
          HeaderView(
            filters: _filters,
            selectedFilter: _selectedFilter,
            onSelected: (filter) => setState(() => _selectedFilter = filter),
          ),
          const SizedBox(height: AppSpacing.lg * 2),
          Expanded(
            child: ListView.separated(
              itemCount: _visibleCards.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) =>
                  FeedCard(data: _visibleCards[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedTopBarIcon extends StatelessWidget {
  const _FeedTopBarIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.auto_awesome,
      size: 30,
      color: FigmaColors.brandSecondary,
    );
  }
}
