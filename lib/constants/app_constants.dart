import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

/// Application-wide constants.
class AppConstants {
  AppConstants._();

  /// Base URL for the TaoPulse API.
  ///
  /// Resolved at runtime: an `API_BASE_URL` dart-define takes precedence,
  /// otherwise a platform-aware local fallback is used. `String.fromEnvironment`
  /// defaultValue must be a compile-time constant, so the fallback is applied in
  /// the getter rather than inline.
  static String get apiBaseUrl {
    const configuredBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://icodex.space',
    );
    if (configuredBaseUrl.isNotEmpty) {
      return configuredBaseUrl;
    }

    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:5000';
    }
    return 'http://127.0.0.1:5000';
  }
}
