import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter/foundation.dart';

/// Singleton service for error reporting using Sentry.
class ErrorReportingService {
  /// Reports an error to Sentry.
  Future<void> logError({
    required dynamic error,
    dynamic stackTrace,
    String? context,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
        withScope: (scope) {
          if (context != null) {
            scope.setTag('context', context);
          }
          if (additionalData != null) {
            additionalData.forEach((key, value) {
              scope.setTag(key, value.toString());
            });
          }
        },
      );
    } catch (e) {
      debugPrint('Sentry error: $e - Original error: $error');
    }
  }

  /// Specialized log for synchronization errors.
  Future<void> logSyncError({
    required String operation,
    required String error,
    dynamic stackTrace,
  }) async {
    await logError(
      error: error,
      stackTrace: stackTrace,
      context: 'cloud_sync',
      additionalData: {'operation': operation},
    );
  }

  /// Reports a message to Sentry.
  Future<void> logMessage(
    String message, {
    SentryLevel level = SentryLevel.info,
  }) async {
    await Sentry.captureMessage(message, level: level);
  }
}
