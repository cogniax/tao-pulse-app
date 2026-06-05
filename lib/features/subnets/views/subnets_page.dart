import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../widgets/app_top_bar.dart';
import '../../../widgets/buttons/app_icon_button.dart';
import '../../../widgets/buttons/outlined_text_button.dart';
import '../../../widgets/tab_page_scaffold.dart';
import 'subnet_card.dart';
import 'subnet_search_bar.dart';

class SubnetsPage extends StatefulWidget {
  const SubnetsPage({super.key});

  @override
  State<SubnetsPage> createState() => _SubnetsPageState();
}

class _SubnetsPageState extends State<SubnetsPage> {
  static const _filters = <_SubnetFilter>[
    _SubnetFilter(label: 'All'),
    _SubnetFilter(label: 'Saved', count: '9'),
    _SubnetFilter(label: 'Active', count: '109'),
    _SubnetFilter(label: 'Immune', count: '12'),
    _SubnetFilter(label: 'At risk', count: '109'),
    _SubnetFilter(label: 'Validation'),
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                AppIconButton(
                  icon: const Icon(Icons.tune_rounded),
                  onPressed: () {},
                ),
                const SizedBox(width: 5),
                for (var index = 0; index < _filters.length; index++) ...[
                  _SubnetFilterChip(
                    filter: _filters[index],
                    selected: _filters[index].label == _selectedFilter,
                    onPressed: () =>
                        setState(() => _selectedFilter = _filters[index].label),
                  ),
                  if (index < _filters.length - 1)
                    const SizedBox(width: 5),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            _selectedFilter,
            style: FigmaTypography.footnote.copyWith(
              color: FigmaColors.textNeutralSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: ListView.separated(
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

class _SubnetFilter {
  const _SubnetFilter({
    required this.label,
    this.count,
  });

  final String label;
  final String? count;
}

class _SubnetFilterChip extends StatelessWidget {
  const _SubnetFilterChip({
    required this.filter,
    required this.selected,
    required this.onPressed,
  });

  final _SubnetFilter filter;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (filter.count == null) {
      return OutlinedTextButton(
        label: filter.label,
        selected: selected,
        onPressed: onPressed,
      );
    }

    final fillColor = selected
        ? FigmaColors.neutralInverseSecondary
        : FigmaColors.neutralPrimary;
    final foregroundColor = selected
        ? FigmaColors.neutralPrimary
        : FigmaColors.textNeutralPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: 10),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: FigmaColors.iconNeutralInverseTertiary),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                filter.label,
                style: FigmaTypography.h8Medium.copyWith(
                  color: foregroundColor,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                filter.count!,
                style: FigmaTypography.caption.copyWith(
                  color: selected
                      ? FigmaColors.neutralPrimary.withValues(alpha: 0.72)
                      : const Color(0xFFB1AFB6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
