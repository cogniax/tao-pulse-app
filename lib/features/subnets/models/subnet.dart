import 'subnet_filter.dart';

class Subnet {
  const Subnet({
    required this.netuid,
    required this.name,
    required this.description,
    required this.alphaToken,
    this.category,
    this.price,
    this.priceTrend,
    this.marketCap,
    this.volume24h,
    this.emission,
    this.filterTags = const [],
    this.watching = false,
  });

  final int netuid;
  final String name;
  final String description;
  final String alphaToken;
  final String? category;
  final double? price;
  final double? priceTrend;
  final double? marketCap;
  final double? volume24h;
  final double? emission;
  final List<SubnetFilterType> filterTags;
  final bool watching;
}
