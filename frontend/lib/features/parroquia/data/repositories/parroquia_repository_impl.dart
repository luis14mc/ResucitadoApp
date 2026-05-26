import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/data/repository_base.dart';
import '../../domain/entities/parroquia_info.dart';
import '../../domain/repositories/parroquia_repository.dart';
import '../datasources/parroquia_remote_datasource.dart';
import '../datasources/parroquia_local_datasource.dart';

@Injectable(as: ParroquiaRepository)
class ParroquiaRepositoryImpl extends RepositoryBase
    implements ParroquiaRepository {
  final ParroquiaRemoteDataSource remoteDataSource;
  final ParroquiaLocalDataSource localDataSource;

  ParroquiaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required NetworkInfo networkInfo,
  }) : super(networkInfo: networkInfo);

  @override
  Future<Either<Failure, ParroquiaInfo>> getParroquiaInfo() async {
    // Intentar obtener de caché primero
    final cached = await localDataSource.getCachedInfo();
    if (cached != null) {
      return Right(cached.toEntity());
    }

    // Si no hay caché, obtener de API
    return executeWithErrorHandling(() async {
      final info = await remoteDataSource.getParroquiaInfo();
      await localDataSource.cacheInfo(info);
      return info.toEntity();
    });
  }
}
