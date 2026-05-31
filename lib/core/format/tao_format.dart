/// Formatting helpers for TAO-denominated values shown across the app.
library;

const _compactSteps = <(double, String)>[
  (1000000000000, 'T'),
  (1000000000, 'B'),
  (1000000, 'M'),
  (1000, 'K'),
];

/// Formats [value] compactly with a K/M/B/T suffix.
///
/// Fixes two issues with naive scaling:
/// - missing magnitudes (e.g. `5e9` now reads `5.0B`, not `5000M`);
/// - rounding roll-over at unit boundaries (e.g. `999999` now reads `1.0M`,
///   not `1000K`).
///
/// Values under 1000 keep up to one decimal. Negative values keep their sign.
String formatCompactTao(double value) {
  final sign = value < 0 ? '-' : '';
  final magnitude = value.abs();

  for (var i = 0; i < _compactSteps.length; i++) {
    final (threshold, suffix) = _compactSteps[i];
    if (magnitude < threshold) {
      continue;
    }

    var scaled = magnitude / threshold;
    var decimals = scaled >= 10 ? 0 : 1;
    var unit = suffix;

    // Rounding can push the value up into the next unit (e.g. 999999 / 1000
    // rounds to 1000); promote it so it reads "1.0M" instead of "1000K".
    if (i > 0 && double.parse(scaled.toStringAsFixed(decimals)) >= 1000) {
      final (largerThreshold, largerSuffix) = _compactSteps[i - 1];
      scaled = magnitude / largerThreshold;
      decimals = scaled >= 10 ? 0 : 1;
      unit = largerSuffix;
    }

    return '$sign${scaled.toStringAsFixed(decimals)}$unit';
  }

  if (magnitude % 1 == 0) {
    return '$sign${magnitude.toStringAsFixed(0)}';
  }
  return '$sign${magnitude.toStringAsFixed(1)}';
}

/// Formats [value] with more precision for small, price-like amounts: 2
/// decimals at or above 1, 3 decimals at or above 0.1, otherwise 4. Uses the
/// magnitude for thresholds so negative values are formatted consistently.
String formatPreciseTao(double value) {
  final sign = value < 0 ? '-' : '';
  final magnitude = value.abs();

  if (magnitude >= 1) {
    return '$sign${magnitude.toStringAsFixed(2)}';
  }
  if (magnitude >= 0.1) {
    return '$sign${magnitude.toStringAsFixed(3)}';
  }
  return '$sign${magnitude.toStringAsFixed(4)}';
}
