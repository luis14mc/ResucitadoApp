import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/data/repository_base.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/horario_misa.dart';
import '../../domain/repositories/horarios_repository.dart';
import '../datasources/horarios_remote_datasource.dart';
import '../datasources/horarios_local_datasource.dart';

@LazySingleton(as: HorariosRepository)
class HorariosRepositoryImpl extends RepositoryBase
    implements HorariosRepository {
  final HorariosRemoteDataSource remoteDataSource;
  final HorariosLocalDataSource localDataSource;

  HorariosRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required super.networkInfo,
  });

  @override
  Future<Either<Failure, List<HorarioMisa>>> getHorariosActivos() async {
    // Primero intentar obtener del caché
    try {
      final cachedHorarios = await localDataSource.getCachedHorarios();
      if (cachedHorarios != null && cachedHorarios.isNotEmpty) {
        return Right(cachedHorarios);
      }
    } catch (e) {
      // Si falla el caché, continuar con la petición remota
    }

    // Si no hay caché válido, obtener de la red
    return executeWithErrorHandling(
      () async {
        final horarios = await remoteDataSource.getHorariosActivos();
        // Guardar en caché
        await localDataSource.cacheHorarios(horarios);
        return horarios;
      },
    );
  }

  @override
  Future<Either<Failure, List<HorarioMisa>>> getHorariosPorTipo(
      TipoMisa tipo) async {
    return executeWithErrorHandling(
      () => remoteDataSource.getHorariosPorTipo(tipo.name),
    );
  }

  @override
  Future<Either<Failure, List<HorarioMisa>>> getHorariosPorDia(
      DiaSemana dia) async {
    return executeWithErrorHandling(
      () => remoteDataSource.getHorariosPorDia(dia.name),
    );
  }

  @override
  Future<Either<Failure, HorarioMisa>> getHorarioPorId(String id) async {
    return executeWithErrorHandling(
      () => remoteDataSource.getHorarioPorId(id),
    );
  }
}
