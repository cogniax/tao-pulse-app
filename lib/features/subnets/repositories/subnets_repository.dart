import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/subnet_filter.dart';
import '../models/subnet.dart';

part 'subnets_repository.g.dart';

@riverpod
SubnetsRepository subnetsRepository(Ref ref) {
  return const SubnetsRepository();
}

class SubnetsRepository {
  const SubnetsRepository();

  Future<List<SubnetFilter>> getFilters() async {
    return const [
      SubnetFilter(type: SubnetFilterType.all),
      SubnetFilter(type: SubnetFilterType.saved, count: '9'),
      SubnetFilter(type: SubnetFilterType.active, count: '109'),
      SubnetFilter(type: SubnetFilterType.immune, count: '12'),
      SubnetFilter(type: SubnetFilterType.atRisk, count: '109'),
      SubnetFilter(type: SubnetFilterType.validation),
    ];
  }

  Future<List<Subnet>> getSubnets() async {
    return [
      Subnet(
        netuid: 74,
        name: 'Apex',
        description:
            'Generative AI subnet focused on model creation and deployment.',
        alphaToken: 'A',
        category: 'Generative Ai',
        price: 0.043,
        priceTrend: 1.2,
        marketCap: 85110,
        volume24h: 105100,
        emission: 4.12,
        filterTags: _mapFilterTags(const ['saved', 'active']),
        watching: true,
      ),
      Subnet(
        netuid: 21,
        name: 'Targon',
        description:
            'Foundation model subnet centered on large-scale reasoning systems.',
        alphaToken: 'T',
        category: 'Foundation Models',
        price: 0.038,
        priceTrend: 0.8,
        marketCap: 72400,
        volume24h: 84700,
        emission: 3.66,
        filterTags: _mapFilterTags(const ['active']),
      ),
      Subnet(
        netuid: 12,
        name: 'Gradients',
        description:
            'Inference network subnet serving low-latency model execution.',
        alphaToken: 'G',
        category: 'Inference Network',
        price: 0.051,
        priceTrend: 2.4,
        marketCap: 91030,
        volume24h: 116900,
        emission: 4.88,
        filterTags: _mapFilterTags(const ['immune']),
      ),
      Subnet(
        netuid: 63,
        name: 'Cortex',
        description:
            'Validation layer subnet focused on verification and trust scoring.',
        alphaToken: 'C',
        category: 'Validation Layer',
        price: 0.029,
        priceTrend: 0.5,
        marketCap: 61240,
        volume24h: 63200,
        emission: 2.91,
        filterTags: _mapFilterTags(const ['at_risk', 'validation']),
      ),
    ];
  }
}

List<SubnetFilterType> _mapFilterTags(List<String> rawTags) {
  return rawTags.map(_filterTypeFromRaw).whereType<SubnetFilterType>().toList();
}

SubnetFilterType? _filterTypeFromRaw(String rawTag) {
  return switch (rawTag.trim().toLowerCase()) {
    'all' => SubnetFilterType.all,
    'saved' => SubnetFilterType.saved,
    'active' => SubnetFilterType.active,
    'immune' => SubnetFilterType.immune,
    'at_risk' || 'at-risk' || 'at risk' => SubnetFilterType.atRisk,
    'validation' => SubnetFilterType.validation,
    _ => null,
  };
}
