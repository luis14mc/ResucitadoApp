import '../../domain/entities/evento.dart';

abstract class EventosRemoteDataSource {
  Future<List<Evento>> getEventosActivos();
  Future<List<Evento>> getEventosPorCategoria(EventoCategoria categoria);
  Future<List<Evento>> getEventosPorFecha(DateTime fecha);
  Future<List<Evento>> getEventosEntreFechas(DateTime inicio, DateTime fin);
  Future<Evento> getEventoPorId(String id);
  Future<List<Evento>> buscarEventos(String query);
  Future<void> inscribirseEvento(
      String eventoId, Map<String, dynamic> datosParticipante);
  Future<void> cancelarInscripcion(String eventoId, String participanteId);
  Future<List<Evento>> getTodosEventos({int page = 1, int limit = 20});
}
