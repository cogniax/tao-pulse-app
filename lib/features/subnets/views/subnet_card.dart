import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../widgets/surface_card.dart';

class SubnetCardData {
  const SubnetCardData({
    required this.netuid,
    required this.name,
    required this.category,
    required this.price,
    required this.priceTrend,
    required this.marketCap,
    required this.volume24h,
    required this.emission,
    this.watching = false,
  });

  final String netuid;
  final String name;
  final String category;
  final String price;
  final String priceTrend;
  final String marketCap;
  final String volume24h;
  final String emission;
  final bool watching;
}

class SubnetCard extends StatelessWidget {
  const SubnetCard({
    super.key,
    required this.data,
  });

  final SubnetCardData data;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.fromLTRB(19, 10, 19, 10),
      borderRadius: AppRadius.xxl,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: FigmaColors.neutralPrimary,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: FigmaColors.iconNeutralInverseTertiary,
                  ),
                ),
                child: Text(
                  data.netuid,
                  style: FigmaTypography.compactBodySmallMedium.copyWith(
                    color: FigmaColors.textNeutralPrimary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: FigmaTypography.h7Semibold.copyWith(
                        color: FigmaColors.textNeutralPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      data.category,
                      style: FigmaTypography.compactBodySmallMedium.copyWith(
                        color: FigmaColors.textNeutralInversePrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: FigmaColors.neutralSecondary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  data.watching ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                  color: data.watching
                      ? FigmaColors.brandSecondary
                      : FigmaColors.iconNeutralPrimary,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MetricColumn(
                label: 'Price',
                value: data.price,
                trend: data.priceTrend,
                trendColor: FigmaColors.textSuccessSubtle,
              ),
              _MetricColumn(
                label: 'Mkt Cap',
                value: data.marketCap,
              ),
              _MetricColumn(
                label: '24h Volume',
                value: data.volume24h,
              ),
              _MetricColumn(
                label: 'emission',
                value: data.emission,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricColumn extends StatelessWidget {
  const _MetricColumn({
    required this.label,
    required this.value,
    this.trend,
    this.trendColor = FigmaColors.textNeutralPrimary,
  });

  final String label;
  final String value;
  final String? trend;
  final Color trendColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: FigmaTypography.footnote.copyWith(
              color: FigmaColors.textNeutralTertiary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 1),
          Text(
            value,
            style: FigmaTypography.compactBodySmallMedium.copyWith(
              color: FigmaColors.textNeutralPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 1),
          SizedBox(
            height: 12,
            child: trend == null
                ? const SizedBox.shrink()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        size: 8,
                        color: trendColor,
                      ),
                      const SizedBox(width: 1),
                      Text(
                        trend!,
                        style: FigmaTypography.footnote.copyWith(
                          color: trendColor,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
