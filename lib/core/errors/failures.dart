import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({String message = 'Server error occurred', int? statusCode})
      : super(message: message, statusCode: statusCode);
}

class CacheFailure extends Failure {
  const CacheFailure({String message = 'Cache error occurred'})
      : super(message: message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({String message = 'No internet connection'})
      : super(message: message);
}

class ValidationFailure extends Failure {
  const ValidationFailure({required String message})
      : super(message: message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({String message = 'Unauthorized access'})
      : super(message: message);
}

class BiometricFailure extends Failure {
  const BiometricFailure({String message = 'Biometric authentication failed'})
      : super(message: message);
}