import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../widgets/surface_card.dart';

class FeedCardData {
  const FeedCardData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.indicator,
    required this.badge,
    required this.tags,
    required this.filters,
    this.icon = Icons.show_chart_rounded,
  });

  final String title;
  final String subtitle;
  final String description;
  final String indicator;
  final String badge;
  final List<String> tags;
  final List<String> filters;
  final IconData icon;
}

class FeedCard extends StatelessWidget {
  const FeedCard({
    super.key,
    required this.data,
  });

  final FeedCardData data;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.fromLTRB(19, 20, 19, 20),
      borderRadius: AppRadius.xxl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: FigmaColors.iconNeutralInverseTertiary,
                          width: 0.5,
                        ),
                      ),
                      child: Icon(
                        data.icon,
                        size: 18,
                        color: FigmaColors.brandPrimary,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.title,
                            style: FigmaTypography.h7Regular.copyWith(
                              color: FigmaColors.textNeutralPrimary,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            data.subtitle,
                            style:
                                FigmaTypography.compactBodySmallMedium.copyWith(
                                  color:
                                      FigmaColors.textNeutralInversePrimary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Padding(
                padding: EdgeInsets.only(top: AppSpacing.xs),
                child: Icon(
                  Icons.thumb_up_alt_outlined,
                  size: 20,
                  color: FigmaColors.iconNeutralPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(
            height: 1,
            thickness: 1,
            color: FigmaColors.neutralSecondary,
          ),
          const SizedBox(height: 18),
          Text(
            data.description,
            style: FigmaTypography.compactBodySmallRegular.copyWith(
              color: FigmaColors.textNeutralPrimary,
            ),
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 14,
                color: FigmaColors.brandPrimary,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  data.indicator,
                  style: FigmaTypography.compactBodySmallRegular.copyWith(
                    color: FigmaColors.brandPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FeedCardChip(
                  label: data.badge,
                  borderRadius: 8,
                ),
                for (final tag in data.tags) ...[
                  const SizedBox(width: 5),
                  _FeedCardChip(
                    label: tag,
                    borderRadius: AppRadius.full,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedCardChip extends StatelessWidget {
  const _FeedCardChip({
    required this.label,
    required this.borderRadius,
  });

  final String label;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: 11),
      decoration: BoxDecoration(
        color: FigmaColors.neutralSecondary,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        label,
        style: FigmaTypography.compactBodySmallRegular.copyWith(
          color: FigmaColors.textNeutralSecondary,
        ),
      ),
    );
  }
}
