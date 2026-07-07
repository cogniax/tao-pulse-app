import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/settings_dashboard.dart';
import '../repositories/settings_repository.dart';

part 'settings_notifier.g.dart';

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Future<SettingsDashboard> build() {
    return ref.read(settingsRepositoryProvider).getDashboard();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(settingsRepositoryProvider).getDashboard(),
    );
  }
}
