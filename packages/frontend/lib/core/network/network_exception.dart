class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  const NetworkException({required this.message, this.statusCode});

  @override
  String toString() => 'NetworkException: $message (Status: $statusCode)';
}

class ServerException extends NetworkException {
  const ServerException({required super.message, super.statusCode});
}

class TimeoutException extends NetworkException {
  const TimeoutException({required super.message, super.statusCode});
}

class UnknownException extends NetworkException {
  const UnknownException({required super.message, super.statusCode});
}

class GeneralException extends NetworkException {
  const GeneralException({required super.message, super.statusCode});
}
