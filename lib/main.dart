import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'services/shared_preferences_provider.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  // Hold the native splash (the "TaoPulse" wordmark) on screen until the first
  // Flutter frame is ready, so the hand-off to SplashPage has no black flash.
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  final preferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      child: const TaoPulseApp(),
    ),
  );
}
