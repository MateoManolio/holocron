/// Interface for a cancellation token to avoid leaking Dio's CancelToken
/// to the domain/presentation layers.
abstract class AppCancellationToken {
  /// Cancels the associated request.
  void cancel([String? reason]);

  /// Returns true if the token is already cancelled.
  bool get isCancelled;

  /// Internal property to get the specific implementation token (e.g. Dio's CancelToken)
  Object? get token;
}

/// A standard implementation of [AppCancellationToken] that doesn't depend on any library.
class DefaultAppCancellationToken implements AppCancellationToken {
  bool _isCancelled = false;
  String? _reason;

  @override
  void cancel([String? reason]) {
    _isCancelled = true;
    _reason = reason;
  }

  @override
  bool get isCancelled => _isCancelled;

  @override
  Object? get token => null;

  String? get reason => _reason;
}

