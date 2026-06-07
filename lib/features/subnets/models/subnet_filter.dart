class SubnetFilter {
  const SubnetFilter({required this.type, this.count});

  final SubnetFilterType type;
  final String? count;
}

enum SubnetFilterType { all, saved, active, immune, atRisk, validation }

extension SubnetFilterTypeLabel on SubnetFilterType {
  String get label {
    return switch (this) {
      SubnetFilterType.all => 'All',
      SubnetFilterType.saved => 'Saved',
      SubnetFilterType.active => 'Active',
      SubnetFilterType.immune => 'Immune',
      SubnetFilterType.atRisk => 'At risk',
      SubnetFilterType.validation => 'Validation',
    };
  }
}
