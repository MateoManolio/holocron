import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:holocron/src/core/services/analytics_service.dart';
import '../../../helpers/mocks.dart';

void main() {
  late AnalyticsService service;
  late MockFirebaseAnalytics mockAnalytics;

  setUp(() {
    mockAnalytics = MockFirebaseAnalytics();
    service = AnalyticsService(mockAnalytics);
  });

  group('AnalyticsService', () {
    test('logEvent should call FirebaseAnalytics.logEvent', () async {
      when(
        () => mockAnalytics.logEvent(
          name: any(named: 'name'),
          parameters: any(named: 'parameters'),
        ),
      ).thenAnswer((_) async => {});

      await service.logEvent(eventName: 'test_event', parameters: {'p': 'v'});

      verify(
        () =>
            mockAnalytics.logEvent(name: 'test_event', parameters: {'p': 'v'}),
      ).called(1);
    });

    test('logSyncError should log error with cloud_sync context', () async {
      when(
        () => mockAnalytics.logEvent(
          name: any(named: 'name'),
          parameters: any(named: 'parameters'),
        ),
      ).thenAnswer((_) async => {});

      await service.logSyncError(operation: 'sync', error: 'fail');

      verify(
        () => mockAnalytics.logEvent(
          name: 'error_occurred',
          parameters: any(
            named: 'parameters',
            that: containsPair('context', 'cloud_sync'),
          ),
        ),
      ).called(1);
    });
  });
}
