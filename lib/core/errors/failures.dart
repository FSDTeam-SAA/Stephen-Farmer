abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error occurred', super.statusCode});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error occurred', super.statusCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Network error occurred', super.statusCode});
}

class ValidationFailure extends Failure {
  const ValidationFailure({super.message = 'Validation error', super.statusCode});
}

class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Authentication error', super.statusCode});
}
