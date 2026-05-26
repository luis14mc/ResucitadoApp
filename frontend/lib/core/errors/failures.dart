import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// Errores de red
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message);
}

// Errores de cache
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

// Errores de validación
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

// Errores de permisos
class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

// Errores generales
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
