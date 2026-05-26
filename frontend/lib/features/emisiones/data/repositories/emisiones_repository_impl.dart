import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/data/repository_base.dart';
import '../../domain/entities/emision.dart';
import '../../domain/repositories/emisiones_repository.dart';
import '../datasources/emisiones_remote_datasource.dart';
import '../datasources/emisiones_local_datasource.dart';

@Injectable(as: EmisionesRepository)
class EmisionesRepositoryImpl extends RepositoryBase
    implements EmisionesRepository {
  final EmisionesRemoteDataSource remoteDataSource;
  final EmisionesLocalDataSource localDataSource;

  EmisionesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required NetworkInfo networkInfo,
  }) : super(networkInfo: networkInfo);

  @override
  Future<Either<Failure, List<Emision>>> getEmisionesActivas() async {
    // Primero intentar obtener del caché
    try {
      final cached = await localDataSource.getCachedEmisiones();
      if (cached != null && cached.isNotEmpty) {
        return Right(cached);
      }
    } catch (e) {
      // Si falla el caché, continuar con la petición remota
    }

    // Si no hay caché válido, obtener de la red
    return executeWithErrorHandling(() async {
      final emisiones = await remoteDataSource.getEmisionesActivas();
      await localDataSource.cacheEmisiones(emisiones);
      return emisiones;
    });
  }

  @override
  Future<Either<Failure, List<Emision>>> getEmisionesPorCategoria(
      String categoria) async {
    return executeWithErrorHandling(
      () => remoteDataSource.getEmisionesPorCategoria(categoria),
    );
  }

  @override
  Future<Either<Failure, List<Emision>>> getEmisionesEnVivo() async {
    return executeWithErrorHandling(
      () => remoteDataSource.getEmisionesEnVivo(),
    );
  }

  @override
  Future<Either<Failure, Emision>> getEmisionPorId(String id) async {
    return executeWithErrorHandling(
      () => remoteDataSource.getEmisionPorId(id),
    );
  }
}
