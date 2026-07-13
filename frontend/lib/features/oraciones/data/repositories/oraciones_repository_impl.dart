import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/data/repository_base.dart';
import '../../domain/entities/oracion.dart';
import '../../domain/repositories/oraciones_repository.dart';
import '../datasources/oraciones_remote_datasource.dart';

class OracionesRepositoryImpl extends RepositoryBase implements OracionesRepository {
  final OracionesRemoteDataSource remoteDataSource;

  OracionesRepositoryImpl({
    required this.remoteDataSource,
    required super.networkInfo,
  });

  @override
  Future<Either<Failure, List<Oracion>>> getOraciones() async {
    return executeWithErrorHandling(() => remoteDataSource.getOraciones());
  }

  @override
  Future<Either<Failure, List<Oracion>>> getOracionesDestacadas() async {
    return executeWithErrorHandling(() => remoteDataSource.getOracionesDestacadas());
  }

  @override
  Future<Either<Failure, List<Oracion>>> getOracionesPorCategoria(String categoria) async {
    return executeWithErrorHandling(() => remoteDataSource.getOracionesPorCategoria(categoria));
  }

  @override
  Future<Either<Failure, Oracion>> getOracionDetalle(String slug) async {
    return executeWithErrorHandling(() => remoteDataSource.getOracionDetalle(slug));
  }
}
