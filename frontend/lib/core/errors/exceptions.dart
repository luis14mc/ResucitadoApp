class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException(this.message, {this.statusCode});
}

class NetworkException implements Exception {
  final String message;

  const NetworkException(this.message);
}

class TimeoutException implements Exception {
  final String message;

  const TimeoutException(this.message);
}

class CacheException implements Exception {
  final String message;

  const CacheException(this.message);
}

class ValidationException implements Exception {
  final String message;

  const ValidationException(this.message);
}

class PermissionException implements Exception {
  final String message;

  const PermissionException(this.message);
}
