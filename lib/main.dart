import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';

void main() {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  // Hold the native splash (the "TaoPulse" wordmark) on screen until the first
  // Flutter frame is ready, so the hand-off to SplashPage has no black flash.
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  runApp(const ProviderScope(child: TaoPulseApp()));
}
