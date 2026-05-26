import 'package:dartz/dartz.dart';
import '../../../../core/data/repository_base.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/lectura.dart';
import '../../domain/repositories/lecturas_repository.dart';
import '../datasources/lecturas_remote_datasource.dart';
import '../datasources/lecturas_local_datasource.dart';

/// Implementación del repository de lecturas
class LecturasRepositoryImpl extends RepositoryBase
    implements LecturasRepository {
  final LecturasRemoteDataSource remoteDataSource;
  final LecturasLocalDataSource localDataSource;

  LecturasRepositoryImpl({
    required super.networkInfo,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Lectura>> getLecturasDelDia() async {
    // Primero intentar obtener del caché
    try {
      final cachedLecturas = await localDataSource.getCachedLecturasDelDia();
      if (cachedLecturas != null) {
        return Right(cachedLecturas);
      }
    } catch (e) {
      // Si falla el caché, continuar con la petición remota
    }

    // Si no hay caché válido, obtener de la red
    return executeWithErrorHandling<Lectura>(
      () async {
        final lecturaModel = await remoteDataSource.getLecturasDelDia();
        // Guardar en caché
        await localDataSource.cacheLecturasDelDia(lecturaModel);
        return lecturaModel;
      },
    );
  }

  @override
  Future<Either<Failure, Lectura>> getLecturasPorFecha(DateTime fecha) async {
    // Para consultas por fecha no usamos caché, siempre consultamos la API
    return executeWithErrorHandling<Lectura>(
      () async {
        final lecturaModel = await remoteDataSource.getLecturasPorFecha(fecha);
        return lecturaModel;
      },
    );
  }
}
