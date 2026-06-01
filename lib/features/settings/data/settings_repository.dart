import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(apiClientProvider));
});

final settingsDashboardProvider = FutureProvider<SettingsDashboard>((
  ref,
) async {
  return ref.watch(settingsRepositoryProvider).getDashboard();
});

class SettingsRepository {
  SettingsRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<SettingsDashboard> getDashboard() async {
    final results = await Future.wait([
      _apiClient.get('/api/v1/profile'),
      _apiClient.get('/api/v1/settings'),
      _apiClient.get('/api/v1/watchlist'),
      _apiClient.get('/api/v1/alerts/settings'),
    ]);
    final profileData = results[0];
    final settingsData = results[1];
    final watchlistData = results[2];
    final alertSettingsData = results[3];

    final user = profileData['user'] as Map<String, dynamic>? ?? const {};
    final stats = profileData['stats'] as Map<String, dynamic>? ?? const {};
    final settings = settingsData;
    final watchlist = (watchlistData['items'] as List<dynamic>? ?? <dynamic>[]);
    final activityAlerts =
        (alertSettingsData['activity_alerts'] as Map<String, dynamic>? ??
        const {});

    return SettingsDashboard(
      fullName: user['full_name'] as String? ?? '',
      initials: user['initials'] as String? ?? '',
      watchingEntities: stats['watching_entities'] as int? ?? watchlist.length,
      alertsEnabled: stats['alerts_enabled'] as int? ??
          activityAlerts.values.where((enabled) => enabled == true).length,
      aiConversationsThisMonth:
          stats['ai_conversations_this_month'] as int? ?? 0,
      watchingCountLabel: '+${watchlist.length}',
      notificationSummary:
          '${activityAlerts.values.where((value) => value == true).length} categories on',
      aiPreferenceLabel:
          (settings['ai_preferences'] as Map<String, dynamic>? ??
                  const {})['response_style']
              as String? ??
          'Balanced',
      appearanceLabel:
          (settings['appearance'] as Map<String, dynamic>? ?? const {})['theme']
              as String? ??
          'Dark',
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
