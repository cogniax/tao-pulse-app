import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_logger.g.dart';

/// Single app-wide [AppLogger] instance.
@Riverpod(keepAlive: true)
AppLogger appLogger(Ref ref) => AppLogger();

/// Severity levels emitted by [AppLogger], ordered least to most severe.
enum LogLevel {
  debug(500, 'DEBUG', '🐛'),
  info(800, 'INFO', '🔵'),
  warning(900, 'WARNING', '🟠'),
  error(1000, 'ERROR', '🔴');

  const LogLevel(this.severity, this.label, this.emoji);

  /// `dart:developer` severity value (aligned with `package:logging` levels).
  final int severity;

  /// Human-readable prefix used as the log entry name.
  final String label;

  /// Emoji cue prepended to the label in debug builds for quick scanning.
  final String emoji;

  /// Entry name shown per log line: emoji-prefixed in debug builds, plain
  /// [label] in release so production/CI logs stay ASCII-clean.
  String get displayLabel => kReleaseMode ? label : '$emoji $label';
}

/// App-wide logger.
///
/// Emits entries to the console via [debugPrint] so they surface in the
/// `flutter run` console and Android logcat, each prefixed with its level and
/// tag. Verbose [LogLevel.debug] output is suppressed in release builds to keep
/// production logs quiet.
///
/// Caught errors are forwarded to a [CrashReporter], so a reporting backend
/// (Crashlytics, Sentry, ...) can be wired in later without touching call
/// sites. Until one is configured the default [NoopCrashReporter] drops them.
class AppLogger {
  AppLogger({CrashReporter? crashReporter})
    : _crashReporter = crashReporter ?? const NoopCrashReporter();

  final CrashReporter _crashReporter;

  void debug(String message, {String? tag}) =>
      _log(LogLevel.debug, message, tag: tag);

  void info(String message, {String? tag}) =>
      _log(LogLevel.info, message, tag: tag);

  void warning(String message, {String? tag}) =>
      _log(LogLevel.warning, message, tag: tag);

  /// Logs [message] at error level.
  ///
  /// When [error] is provided it is also recorded via [recordError] so the
  /// crash reporter can capture it as a non-fatal issue. Omit [error] for
  /// log-only error messages.
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    _log(
      LogLevel.error,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
    if (error != null) {
      recordError(error, stackTrace, reason: message);
    }
  }

  /// Records a caught [error] to the crash reporter, non-fatal by default.
  /// Set [fatal] to true for a crash handled just before termination.
  void recordError(
    Object error,
    StackTrace? stackTrace, {
    bool fatal = false,
    String? reason,
  }) {
    _crashReporter.recordError(error, stackTrace, fatal: fatal, reason: reason);
  }

  /// Attaches [key]/[value] metadata to subsequent crash reports.
  void setCustomKey(String key, Object value) =>
      _crashReporter.setCustomKey(key, value);

  /// Tags subsequent crash reports with [identifier] (e.g. user/session id).
  void setUserIdentifier(String identifier) =>
      _crashReporter.setUserIdentifier(identifier);

  void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Debug chatter is development-only; keep release logs quiet.
    if (kReleaseMode && level == LogLevel.debug) return;

    // Emit to the console via debugPrint so entries surface in the `flutter
    // run` console and Android logcat. The level label and tag are prefixed
    // onto the body so flat output stays greppable.
    final tagPrefix = tag != null ? '[$tag] ' : '';
    debugPrint('${level.displayLabel} $tagPrefix$message');
    if (error != null) {
      debugPrint('${level.displayLabel} ${tagPrefix}Error: $error');
    }
    if (stackTrace != null) {
      debugPrint('$stackTrace');
    }
  }
}

/// Sink for the errors and diagnostic metadata gathered by [AppLogger].
///
/// Implement this to forward reports to a backend such as Firebase
/// Crashlytics or Sentry, then pass the implementation to [AppLogger.new]
/// (typically by overriding [appLoggerProvider] at app start-up).
abstract interface class CrashReporter {
  void recordError(
    Object error,
    StackTrace? stackTrace, {
    bool fatal,
    String? reason,
  });

  void setCustomKey(String key, Object value);

  void setUserIdentifier(String identifier);
}

/// [CrashReporter] that discards everything. Used until a real crash-reporting
/// backend is configured.
class NoopCrashReporter implements CrashReporter {
  const NoopCrashReporter();

  @override
  void recordError(
    Object error,
    StackTrace? stackTrace, {
    bool fatal = false,
    String? reason,
  }) {}

  @override
  void setCustomKey(String key, Object value) {}

  @override
  void setUserIdentifier(String identifier) {}
}
