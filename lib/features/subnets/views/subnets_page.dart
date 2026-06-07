import 'package:flutter/material.dart';

import '../models/subnet_filter.dart';
import '../../../theme/theme.dart';
import '../../../widgets/app_top_bar.dart';
import '../../../widgets/tab_page_scaffold.dart';
import 'subnet_card.dart';
import 'subnet_filter_bar.dart';
import 'subnet_search_bar.dart';

class SubnetsPage extends StatefulWidget {
  const SubnetsPage({super.key});

  @override
  State<SubnetsPage> createState() => _SubnetsPageState();
}

class _SubnetsPageState extends State<SubnetsPage> {
  static const _filters = <SubnetFilter>[
    SubnetFilter(label: 'All'),
    SubnetFilter(label: 'Saved', count: '9'),
    SubnetFilter(label: 'Active', count: '109'),
    SubnetFilter(label: 'Immune', count: '12'),
    SubnetFilter(label: 'At risk', count: '109'),
    SubnetFilter(label: 'Validation'),
  ];

  static const _cards = <SubnetCardData>[
    SubnetCardData(
      netuid: 'SN 74',
      name: 'Apex',
      category: 'Generative Ai',
      price: '0.043 T',
      priceTrend: '1.2%',
      marketCap: 'T 85.11k',
      volume24h: '\$105.1k',
      emission: '4.12%',
      watching: true,
    ),
    SubnetCardData(
      netuid: 'SN 21',
      name: 'Targon',
      category: 'Foundation Models',
      price: '0.038 T',
      priceTrend: '0.8%',
      marketCap: 'T 72.40k',
      volume24h: '\$84.7k',
      emission: '3.66%',
    ),
    SubnetCardData(
      netuid: 'SN 12',
      name: 'Gradients',
      category: 'Inference Network',
      price: '0.051 T',
      priceTrend: '2.4%',
      marketCap: 'T 91.03k',
      volume24h: '\$116.9k',
      emission: '4.88%',
    ),
    SubnetCardData(
      netuid: 'SN 63',
      name: 'Cortex',
      category: 'Validation Layer',
      price: '0.029 T',
      priceTrend: '0.5%',
      marketCap: 'T 61.24k',
      volume24h: '\$63.2k',
      emission: '2.91%',
    ),
  ];

  String _selectedFilter = _filters.first.label;

  List<SubnetCardData> get _visibleCards => _cards;

  @override
  Widget build(BuildContext context) {
    return TabPageScaffold(
      appBar: const TopBar(
        title: 'Subnets',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),
          const SubnetSearchBar(),
          const SizedBox(height: AppSpacing.xl),
          SubnetFilterBar(
            filters: _filters,
            selectedFilter: _selectedFilter,
            onSelected: (filter) => setState(() => _selectedFilter = filter),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.bottomNavClearance,
              ),
              itemCount: _visibleCards.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 9),
              itemBuilder: (context, index) =>
                  SubnetCard(data: _visibleCards[index]),
            ),
          ),
        ],
      ),
    );
  }
}
