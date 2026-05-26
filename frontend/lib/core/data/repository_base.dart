import 'package:dartz/dartz.dart';
import '../errors/failures.dart';
import '../errors/exceptions.dart';
import '../network/network_info.dart';

/// Clase base abstracta para repositorios
///
/// Provee métodos comunes para manejo de errores y verificación de red
///
/// Ejemplo de uso:
/// ```dart
/// class SantosRepositoryImpl extends RepositoryBase implements SantosRepository {
///   SantosRepositoryImpl({
///     required super.networkInfo,
///     required this.remoteDataSource,
///   });
///
///   final SantosRemoteDataSource remoteDataSource;
///
///   @override
///   Future<Either<Failure, Santo>> getSantoDelDia() async {
///     return executeWithErrorHandling(() => remoteDataSource.getSantoDelDia());
///   }
/// }
/// ```
abstract class RepositoryBase {
  final NetworkInfo networkInfo;

  RepositoryBase({required this.networkInfo});

  /// Ejecuta una acción con manejo de errores estándar
  ///
  /// Verifica la conexión a internet antes de ejecutar la acción
  /// Captura y convierte excepciones en Failures
  Future<Either<Failure, T>> executeWithErrorHandling<T>(
    Future<T> Function() action,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await action();
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on TimeoutException catch (e) {
        return Left(TimeoutFailure(e.message));
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Error inesperado: $e'));
      }
    } else {
      return Left(NetworkFailure('No hay conexión a internet'));
    }
  }

  /// Ejecuta una acción sin verificar la conexión a internet
  ///
  /// Útil para operaciones locales o cuando ya se verificó la conexión
  Future<Either<Failure, T>> executeWithErrorHandlingNoNetwork<T>(
    Future<T> Function() action,
  ) async {
    try {
      final result = await action();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Error inesperado: $e'));
    }
  }
}
