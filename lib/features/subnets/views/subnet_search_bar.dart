import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../widgets/buttons/search_button.dart';

class SubnetSearchBar extends StatelessWidget {
  const SubnetSearchBar({
    super.key,
    this.hintText = 'Search by name or SN number',
  });

  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 6, 6, 6),
      decoration: BoxDecoration(
        color: FigmaColors.neutralPrimary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: FigmaColors.iconNeutralInverseTertiary),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              hintText,
              style: FigmaTypography.compactBodySmallRegular.copyWith(
                color: FigmaColors.textNeutralPrimary.withValues(alpha: 0.6),
              ),
            ),
          ),
          const SearchButton(),
        ],
      ),
    );
  }
}
