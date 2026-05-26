import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Clase base abstracta para casos de uso con parámetros
///
/// [Type] es el tipo de dato que devuelve el caso de uso
/// [Params] es el tipo de parámetros que recibe el caso de uso
///
/// Ejemplo de uso:
/// ```dart
/// class GetSantoDelDia extends UseCase<Santo, NoParams> {
///   @override
///   Future<Either<Failure, Santo>> call(NoParams params) async {
///     // implementación
///   }
/// }
/// ```
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Clase base abstracta para casos de uso sin parámetros
///
/// [Type] es el tipo de dato que devuelve el caso de uso
///
/// Ejemplo de uso:
/// ```dart
/// class GetSantoDelDia extends UseCaseNoParams<Santo> {
///   @override
///   Future<Either<Failure, Santo>> call() async {
///     // implementación
///   }
/// }
/// ```
abstract class UseCaseNoParams<Type> {
  Future<Either<Failure, Type>> call();
}

/// Clase para representar casos de uso sin parámetros
class NoParams {
  const NoParams();
}
