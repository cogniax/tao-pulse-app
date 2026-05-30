/// Formats a TAO [value] into a compact, human-readable string such as
/// `1.2M`, `3K`, or `42`.
///
/// Pure relocation of the former `_formatCompactTao` helper from
/// `SubnetsScreen`, moved here so the formatting rules can be unit-tested
/// without a widget test.
String formatCompactTao(double value) {
  final absolute = value.abs();
  if (absolute >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(absolute >= 10000000 ? 0 : 1)}M';
  }
  if (absolute >= 1000) {
    return '${(value / 1000).toStringAsFixed(absolute >= 10000 ? 0 : 1)}K';
  }
  if (value % 1 == 0) {
    return value.toStringAsFixed(0);
  }
  return value.toStringAsFixed(1);
}
