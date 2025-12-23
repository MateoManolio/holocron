import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

/// Singleton service for Firebase Analytics
/// Provides centralized logging and event tracking
class AnalyticsService {
  final FirebaseAnalytics _analytics;

  AnalyticsService(this._analytics);

  /// Log an error event with details
  Future<void> logError({
    required String error,
    String? context,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'error_occurred',
        parameters: {
          'error_message': error,
          if (context != null) 'context': context,
          if (additionalData != null) ...additionalData,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      // Fallback to print if analytics fails
      debugPrint('Analytics error: $e - Original error: $error');
    }
  }

  /// Log when sync to cloud fails
  Future<void> logSyncError({
    required String operation,
    required String error,
  }) async {
    await logError(
      error: error,
      context: 'cloud_sync',
      additionalData: {'operation': operation},
    );
  }

  /// Log successful events
  Future<void> logEvent({
    required String eventName,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logEvent(name: eventName, parameters: parameters);
    } catch (e) {
      debugPrint('Analytics event error: $e');
    }
  }
}
