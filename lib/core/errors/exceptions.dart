class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

class ServerException extends AppException {
  const ServerException({super.message = 'Server error', super.statusCode});
}

class CacheException extends AppException {
  const CacheException({super.message = 'Cache error', super.statusCode});
}

class NetworkException extends AppException {
  const NetworkException({super.message = 'Network error', super.statusCode});
}

class ValidationException extends AppException {
  const ValidationException({super.message = 'Validation error', super.statusCode});
}

class AuthException extends AppException {
  const AuthException({super.message = 'Authentication error', super.statusCode});
}
