import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/evento.dart';
import '../models/evento_model.dart';
import 'eventos_remote_data_source.dart';

@LazySingleton(as: EventosRemoteDataSource)
class EventosRemoteDataSourceImpl implements EventosRemoteDataSource {
  final DioClient dioClient;

  EventosRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<Evento>> getEventosActivos() async {
    try {
      final response = await dioClient.get(ApiConstants.eventosActivos);

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => EventoModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Error al obtener eventos activos: $e');
    }
  }

  @override
  Future<List<Evento>> getEventosPorCategoria(EventoCategoria categoria) async {
    try {
      final response = await dioClient.get(
        '${ApiConstants.eventosPorCategoria}/${categoria.name}',
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => EventoModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Error al obtener eventos por categoría: $e');
    }
  }

  @override
  Future<List<Evento>> getEventosPorFecha(DateTime fecha) async {
    try {
      final response = await dioClient.get(
        '${ApiConstants.eventos}/fecha',
        queryParameters: {
          'fecha': fecha.toIso8601String(),
        },
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => EventoModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Error al obtener eventos por fecha: $e');
    }
  }

  @override
  Future<List<Evento>> getEventosEntreFechas(
      DateTime inicio, DateTime fin) async {
    try {
      final response = await dioClient.get(
        '${ApiConstants.eventos}/rango',
        queryParameters: {
          'inicio': inicio.toIso8601String(),
          'fin': fin.toIso8601String(),
        },
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => EventoModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Error al obtener eventos en rango: $e');
    }
  }

  @override
  Future<Evento> getEventoPorId(String id) async {
    try {
      final response = await dioClient.get('${ApiConstants.eventos}/$id');

      final json = response.data['data'] ?? response.data;
      return EventoModel.fromJson(json);
    } catch (e) {
      throw ServerException('Error al obtener evento: $e');
    }
  }

  @override
  Future<List<Evento>> buscarEventos(String query) async {
    try {
      final response = await dioClient.get(
        '${ApiConstants.eventos}/buscar',
        queryParameters: {'q': query},
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => EventoModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Error al buscar eventos: $e');
    }
  }

  @override
  Future<void> inscribirseEvento(
      String eventoId, Map<String, dynamic> datosParticipante) async {
    try {
      await dioClient.post(
        '${ApiConstants.eventos}/$eventoId/inscripcion',
        data: datosParticipante,
      );
    } catch (e) {
      throw ServerException('Error al inscribirse al evento: $e');
    }
  }

  @override
  Future<void> cancelarInscripcion(
      String eventoId, String participanteId) async {
    try {
      await dioClient.delete(
        '${ApiConstants.eventos}/$eventoId/inscripcion/$participanteId',
      );
    } catch (e) {
      throw ServerException('Error al cancelar inscripción: $e');
    }
  }

  @override
  Future<List<Evento>> getTodosEventos({int page = 1, int limit = 20}) async {
    try {
      final response = await dioClient.get(
        ApiConstants.eventos,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => EventoModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Error al obtener todos los eventos: $e');
    }
  }
}
