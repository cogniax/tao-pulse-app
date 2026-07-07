import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../constants/local_preference_keys.dart';
import '../../../services/app_logger.dart';
import '../../../services/shared_preferences_provider.dart';
import '../../auth/repositories/auth_repository.dart';

part 'splash_notifier.g.dart';

/// Where to send the user once the splash animation finishes.
enum SplashDestination { home, welcome, login }

/// Resolves the post-splash destination from authentication and first-run
/// state: signed-in users go home, first-run guests see the inline welcome,
/// and returning guests go straight to login.
///
/// This holds the splash's business logic so [SplashPage] can stay a pure view.
@riverpod
class SplashNotifier extends _$SplashNotifier {
  @override
  Future<SplashDestination> build() async {
    ref.keepAlive();
    return determineDestination();
  }

  Future<SplashDestination> determineDestination() async {
    final hasSeenWelcome = _hasSeenWelcome();

    if (await _isAuthenticated()) {
      return SplashDestination.home;
    }

    return hasSeenWelcome ? SplashDestination.login : SplashDestination.welcome;
  }

  Future<bool> _isAuthenticated() async {
    try {
      return await ref.read(authRepositoryProvider).isAuthenticated();
    } catch (error, stackTrace) {
      final logger = ref.read(appLoggerProvider);
      logger.warning(
        'Auth state check failed during splash; treating user as signed out. '
        'Error: $error',
        tag: 'Splash',
      );
      logger.recordError(
        error,
        stackTrace,
        reason: 'Splash auth state check failed.',
      );
      return false;
    }
  }

  bool _hasSeenWelcome() {
    return ref
            .read(sharedPreferencesProvider)
            .getBool(LocalPreferenceKeys.hasSeenWelcome) ??
        false;
  }
}
