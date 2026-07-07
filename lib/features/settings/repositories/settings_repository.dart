import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/settings_dashboard.dart';

part 'settings_repository.g.dart';

@riverpod
SettingsRepository settingsRepository(Ref ref) {
  return const SettingsRepository();
}

class SettingsRepository {
  const SettingsRepository();

  /// Returns the settings dashboard.
  ///
  /// The generated API client currently exposes only the Auth, Health and
  /// Subnets APIs — there is no profile/settings/watchlist endpoint yet — so
  /// this serves curated static values to keep the screen populated. When the
  /// backend ships those endpoints, inject `apiClientProvider` into this
  /// repository (see `AuthRepository` for the pattern) and map the responses
  /// into a [SettingsDashboard].
  Future<SettingsDashboard> getDashboard() async {
    return const SettingsDashboard(
      fullName: 'Alex Carter',
      initials: 'AC',
      watchingEntities: 9,
      alertsEnabled: 5,
      aiConversationsThisMonth: 24,
      watchingCountLabel: '+9',
      notificationSummary: '3 categories on',
      aiPreferenceLabel: 'Balanced',
      appearanceLabel: 'Dark',
    );
  }
}
