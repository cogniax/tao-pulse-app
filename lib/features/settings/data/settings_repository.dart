import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

final settingsDashboardProvider = FutureProvider<SettingsDashboard>((
  ref,
) async {
  return ref.watch(settingsRepositoryProvider).getDashboard();
});

class SettingsRepository {
  SettingsRepository();

  // TODO: wire to the generated API client once the profile/settings/watchlist
  // endpoints are supported. Stubbed with defaults so the build passes.
  Future<SettingsDashboard> getDashboard() async {
    return const SettingsDashboard(
      fullName: '',
      initials: '',
      watchingEntities: 0,
      alertsEnabled: 0,
      aiConversationsThisMonth: 0,
      watchingCountLabel: '+0',
      notificationSummary: '0 categories on',
      aiPreferenceLabel: 'Balanced',
      appearanceLabel: 'Dark',
    );
  }
}

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
