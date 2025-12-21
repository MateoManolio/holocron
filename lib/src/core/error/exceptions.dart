class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

class NetworkException implements Exception {
  final String message;

  NetworkException({required this.message});

  @override
  String toString() => 'NetworkException: $message';
}

class RequestCancelledException implements Exception {
  final String message;

  RequestCancelledException({required this.message});

  @override
  String toString() => 'RequestCancelledException: $message';
}
