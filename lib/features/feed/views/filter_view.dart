import 'package:flutter/material.dart';

import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/buttons/outlined_text_button.dart';

class HeaderView extends StatelessWidget {
  const HeaderView({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
  });

  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your feed',
          style: FigmaTypography.h6Semibold.copyWith(
            color: FigmaColors.textNeutralPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _FilterView(
          filters: filters,
          selectedFilter: selectedFilter,
          onSelected: onSelected,
        ),
      ],
    );
  }
}

class _FilterView extends StatelessWidget {
  const _FilterView({
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
  });

  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < filters.length; index++) ...[
            OutlinedTextButton(
              label: filters[index],
              selected: filters[index] == selectedFilter,
              onPressed: () => onSelected(filters[index]),
            ),
            if (index < filters.length - 1)
              const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
