import 'package:dio/dio.dart';
import 'app_cancellation_token.dart';

/// Dio implementation of [AppCancellationToken]
class DioCancellationToken implements AppCancellationToken {
  final CancelToken _cancelToken = CancelToken();

  @override
  void cancel([String? reason]) => _cancelToken.cancel(reason);

  @override
  bool get isCancelled => _cancelToken.isCancelled;

  @override
  CancelToken get token => _cancelToken;
}

