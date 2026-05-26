import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/evento.dart';

abstract class EventosRepository {
  Future<Either<Failure, List<Evento>>> getEventosActivos();
  Future<Either<Failure, List<Evento>>> getEventosPorCategoria(
      EventoCategoria categoria);
  Future<Either<Failure, List<Evento>>> getEventosPorFecha(DateTime fecha);
  Future<Either<Failure, List<Evento>>> getEventosEntreFechas(
      DateTime inicio, DateTime fin);
  Future<Either<Failure, Evento>> getEventoPorId(String id);
  Future<Either<Failure, List<Evento>>> buscarEventos(String query);
  Future<Either<Failure, void>> inscribirseEvento(
      String eventoId, Map<String, dynamic> datosParticipante);
  Future<Either<Failure, void>> cancelarInscripcion(
      String eventoId, String participanteId);
  Future<Either<Failure, List<Evento>>> getTodosEventos({
    int page = 1,
    int limit = 20,
  });
}
