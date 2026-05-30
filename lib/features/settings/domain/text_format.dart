/// Capitalizes the first character of [value], leaving the remainder unchanged.
///
/// Pure relocation of the former `_titleCase` helper from `SettingsScreen`,
/// moved here so the formatting rule can be unit-tested without a widget test.
String titleCase(String value) {
  if (value.isEmpty) {
    return value;
  }
  return value[0].toUpperCase() + value.substring(1);
}
