import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../widgets/buttons/search_button.dart';

class SubnetSearchBar extends StatelessWidget {
  const SubnetSearchBar({
    super.key,
    this.hintText = 'Search by name or SN number',
    this.onTap,
  });

  final String hintText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
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
                      color: FigmaColors.textNeutralPrimary.withValues(
                        alpha: 0.6,
                      ),
                    ),
                  ),
                ),
                const IgnorePointer(child: SearchButton()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
