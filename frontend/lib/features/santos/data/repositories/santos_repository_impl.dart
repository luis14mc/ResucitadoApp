import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/data/repository_base.dart';
import '../../domain/entities/santo.dart';
import '../../domain/repositories/santos_repository.dart';
import '../datasources/santos_remote_data_source.dart';
import '../datasources/santos_local_datasource.dart';
import '../models/santo_model.dart';

@LazySingleton(as: SantosRepository)
class SantosRepositoryImpl extends RepositoryBase implements SantosRepository {
  final SantosRemoteDataSource remoteDataSource;
  final SantosLocalDataSource localDataSource;

  SantosRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required super.networkInfo,
  });

  @override
  Future<Either<Failure, Santo>> getSantoDelDia() async {
    // Primero intentar obtener del caché
    try {
      final cachedSanto = await localDataSource.getCachedSantoDelDia();
      if (cachedSanto != null) {
        return Right(cachedSanto);
      }
    } catch (e) {
      // Si falla el caché, continuar con la petición remota
    }

    // Si no hay caché válido, obtener de la red
    return executeWithErrorHandling(
      () async {
        final santo = await remoteDataSource.getSantoDelDia();
        // Guardar en caché (convertir a modelo si es necesario)
        final santoModel =
            santo is SantoModel ? santo : SantoModel.fromEntity(santo);
        await localDataSource.cacheSantoDelDia(santoModel);
        return santo;
      },
    );
  }

  @override
  Future<Either<Failure, List<Santo>>> getSantosPorMes(int mes) async {
    return executeWithErrorHandling(
      () => remoteDataSource.getSantosPorMes(mes),
    );
  }

  @override
  Future<Either<Failure, List<Santo>>> getSantosPorFecha(DateTime fecha) async {
    return executeWithErrorHandling(
      () => remoteDataSource.getSantosPorFecha(fecha),
    );
  }

  @override
  Future<Either<Failure, List<Santo>>> buscarSantos(String query) async {
    return executeWithErrorHandling(
      () => remoteDataSource.buscarSantos(query),
    );
  }

  @override
  Future<Either<Failure, Santo>> getSantoPorId(String id) async {
    return executeWithErrorHandling(
      () => remoteDataSource.getSantoPorId(id),
    );
  }

  @override
  Future<Either<Failure, List<Santo>>> getTodosSantos({
    int page = 1,
    int limit = 20,
  }) async {
    return executeWithErrorHandling(
      () => remoteDataSource.getTodosSantos(page: page, limit: limit),
    );
  }
}
