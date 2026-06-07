import 'package:flutter/material.dart';

import '../models/subnet_filter.dart';
import '../../../theme/theme.dart';
import '../../../widgets/buttons/app_icon_button.dart';
import '../../../widgets/buttons/outlined_text_button.dart';

class SubnetFilterBar extends StatelessWidget {
  const SubnetFilterBar({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
    this.onSortPressed,
  });

  final List<SubnetFilter> filters;
  final SubnetFilterType selectedFilter;
  final ValueChanged<SubnetFilterType> onSelected;
  final VoidCallback? onSortPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                AppIconButton(
                  icon: const Icon(Icons.tune_rounded),
                  onPressed: onSortPressed ?? () {},
                ),
                const SizedBox(width: 5),
                for (var index = 0; index < filters.length; index++) ...[
                  _SubnetFilterChip(
                    filter: filters[index],
                    selected: filters[index].type == selectedFilter,
                    onPressed: () => onSelected(filters[index].type),
                  ),
                  if (index < filters.length - 1) const SizedBox(width: 5),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SubnetFilterChip extends StatelessWidget {
  const _SubnetFilterChip({
    required this.filter,
    required this.selected,
    required this.onPressed,
  });

  final SubnetFilter filter;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (filter.count == null) {
      return OutlinedTextButton(
        label: filter.type.label,
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
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: FigmaColors.iconNeutralInverseTertiary),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                filter.type.label,
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
                      : FigmaColors.textNeutralTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
