/// Aggregated data backing the settings screen: the user's profile summary
/// plus the headline counts and labels shown on each settings card.
class SettingsDashboard {
  const SettingsDashboard({
    required this.fullName,
    required this.initials,
    required this.watchingEntities,
    required this.alertsEnabled,
    required this.aiConversationsThisMonth,
    required this.watchingCountLabel,
    required this.notificationSummary,
    required this.aiPreferenceLabel,
    required this.appearanceLabel,
  });

  final String fullName;
  final String initials;
  final int watchingEntities;
  final int alertsEnabled;
  final int aiConversationsThisMonth;
  final String watchingCountLabel;
  final String notificationSummary;
  final String aiPreferenceLabel;
  final String appearanceLabel;
}
