import 'package:flutter/foundation.dart';

/// Lightweight logger for debug builds.
class AppLogger {
  static void d(String message, {Object? data}) {
    if (kDebugMode) {
      debugPrint('[DEBUG] $message ${data ?? ''}');
    }
  }

  static void e(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      debugPrint('[ERROR] $message ${error ?? ''}');
      if (stackTrace != null) debugPrint(stackTrace.toString());
    }
  }
}

