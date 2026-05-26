import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/data/repository_base.dart';
import '../../domain/entities/evento.dart';
import '../../domain/repositories/eventos_repository.dart';
import '../datasources/eventos_remote_data_source.dart';
import '../datasources/eventos_local_datasource.dart';
import '../models/evento_model.dart';

@LazySingleton(as: EventosRepository)
class EventosRepositoryImpl extends RepositoryBase
    implements EventosRepository {
  final EventosRemoteDataSource remoteDataSource;
  final EventosLocalDataSource localDataSource;

  EventosRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required super.networkInfo,
  });

  @override
  Future<Either<Failure, List<Evento>>> getEventosActivos() async {
    // Primero intentar obtener del caché
    try {
      final cachedEventos = await localDataSource.getCachedEventosActivos();
      if (cachedEventos != null && cachedEventos.isNotEmpty) {
        return Right(cachedEventos);
      }
    } catch (e) {
      // Si falla el caché, continuar con la petición remota
    }

    // Si no hay caché válido, obtener de la red
    return executeWithErrorHandling(
      () async {
        final eventos = await remoteDataSource.getEventosActivos();
        // Guardar en caché (convertir List<Evento> a List<EventoModel>)
        final eventosModels = eventos
            .map((e) => e is EventoModel ? e : EventoModel.fromEntity(e))
            .cast<EventoModel>()
            .toList();
        await localDataSource.cacheEventosActivos(eventosModels);
        return eventos;
      },
    );
  }

  @override
  Future<Either<Failure, List<Evento>>> getEventosPorCategoria(
      EventoCategoria categoria) async {
    return executeWithErrorHandling(
      () => remoteDataSource.getEventosPorCategoria(categoria),
    );
  }

  @override
  Future<Either<Failure, List<Evento>>> getEventosPorFecha(
      DateTime fecha) async {
    return executeWithErrorHandling(
      () => remoteDataSource.getEventosPorFecha(fecha),
    );
  }

  @override
  Future<Either<Failure, List<Evento>>> getEventosEntreFechas(
      DateTime inicio, DateTime fin) async {
    return executeWithErrorHandling(
      () => remoteDataSource.getEventosEntreFechas(inicio, fin),
    );
  }

  @override
  Future<Either<Failure, Evento>> getEventoPorId(String id) async {
    return executeWithErrorHandling(
      () => remoteDataSource.getEventoPorId(id),
    );
  }

  @override
  Future<Either<Failure, List<Evento>>> buscarEventos(String query) async {
    return executeWithErrorHandling(
      () => remoteDataSource.buscarEventos(query),
    );
  }

  @override
  Future<Either<Failure, void>> inscribirseEvento(
      String eventoId, Map<String, dynamic> datosParticipante) async {
    return executeWithErrorHandling(
      () => remoteDataSource.inscribirseEvento(eventoId, datosParticipante),
    );
  }

  @override
  Future<Either<Failure, void>> cancelarInscripcion(
      String eventoId, String participanteId) async {
    return executeWithErrorHandling(
      () => remoteDataSource.cancelarInscripcion(eventoId, participanteId),
    );
  }

  @override
  Future<Either<Failure, List<Evento>>> getTodosEventos({
    int page = 1,
    int limit = 20,
  }) async {
    return executeWithErrorHandling(
      () => remoteDataSource.getTodosEventos(page: page, limit: limit),
    );
  }
}
