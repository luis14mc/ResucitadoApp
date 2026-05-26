import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/data/repository_base.dart';
import '../../domain/entities/oficina_info.dart';
import '../../domain/repositories/oficina_repository.dart';
import '../datasources/oficina_remote_datasource.dart';
import '../datasources/oficina_local_datasource.dart';

@Injectable(as: OficinaRepository)
class OficinaRepositoryImpl extends RepositoryBase
    implements OficinaRepository {
  final OficinaRemoteDataSource remoteDataSource;
  final OficinaLocalDataSource localDataSource;

  OficinaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required NetworkInfo networkInfo,
  }) : super(networkInfo: networkInfo);

  @override
  Future<Either<Failure, OficinaInfo>> getOficinaInfo() async {
    final cached = await localDataSource.getCachedInfo();
    if (cached != null) {
      return Right(cached.toEntity());
    }

    return executeWithErrorHandling(() async {
      final info = await remoteDataSource.getOficinaInfo();
      await localDataSource.cacheInfo(info);
      return info.toEntity();
    });
  }
}
