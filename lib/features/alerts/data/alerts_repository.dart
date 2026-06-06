import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/api_client.dart';

final alertsRepositoryProvider = Provider<AlertsRepository>((ref) {
  return AlertsRepository(ref.watch(apiClientProvider));
});

final alertsProvider = FutureProvider.family<List<AlertItem>, String>((
  ref,
  filter,
) async {
  return ref.watch(alertsRepositoryProvider).getAlerts(filter: filter);
});

final alertSettingsProvider = FutureProvider<AlertSettings>((ref) async {
  return ref.watch(alertsRepositoryProvider).getAlertSettings();
});

class AlertsRepository {
  AlertsRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<AlertItem>> getAlerts({String filter = 'All'}) async {
    final normalized = filter.toLowerCase();
    final query = normalized == 'all' ? null : {'filter': normalized};
    final data = await _apiClient.get('/api/v1/alerts', queryParameters: query);
    return (data['items'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(AlertItem.fromJson)
        .toList();
  }

  Future<AlertSettings> getAlertSettings() async {
    final data = await _apiClient.get('/api/v1/alerts/settings');
    return AlertSettings.fromJson(data);
  }

  Future<AlertSettings> updateAlertSettings(AlertSettings settings) async {
    final data = await _apiClient.put(
      '/api/v1/alerts/settings',
      data: settings.toJson(),
    );
    return AlertSettings.fromJson(data);
  }
}

class AlertItem {
  const AlertItem({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.severity,
    required this.primaryAction,
  });

  final String id;
  final String category;
  final String title;
  final String description;
  final String timeAgo;
  final String severity;
  final String primaryAction;

  factory AlertItem.fromJson(Map<String, dynamic> json) {
    return AlertItem(
      id: json['id'] as String? ?? '',
      category: json['category'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      timeAgo: json['time_ago'] as String? ?? '',
      severity: json['severity'] as String? ?? '',
      primaryAction: json['primary_action'] as String? ?? 'View',
    );
  }
}

class AlertSettings {
  const AlertSettings({
    required this.subnetName,
    required this.netuid,
    required this.watching,
    required this.activityAlerts,
    required this.otherAlerts,
  });

  final String subnetName;
  final int netuid;
  final bool watching;
  final Map<String, bool> activityAlerts;
  final Map<String, bool> otherAlerts;

  factory AlertSettings.fromJson(Map<String, dynamic> json) {
    final subnet = json['subnet'] as Map<String, dynamic>? ?? const {};
    return AlertSettings(
      subnetName: subnet['name'] as String? ?? 'Subnet',
      netuid: subnet['netuid'] as int? ?? 0,
      watching: subnet['watching'] as bool? ?? false,
      activityAlerts:
          (json['activity_alerts'] as Map<String, dynamic>? ?? const {}).map(
            (key, value) => MapEntry(key, value == true),
          ),
      otherAlerts: (json['other_alerts'] as Map<String, dynamic>? ?? const {})
          .map((key, value) => MapEntry(key, value == true)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subnet': {'name': subnetName, 'netuid': netuid, 'watching': watching},
      'activity_alerts': activityAlerts,
      'other_alerts': otherAlerts,
    };
  }
}
