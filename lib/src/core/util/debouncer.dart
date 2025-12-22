import 'dart:async';

/// A simple debouncer to delay the execution of a function.
/// Useful for search fields or other inputs that trigger expensive operations.
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

