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

  Map<String, dynamic> _extractMap(dynamic data) {
    if (data is Map) {
      if (data.containsKey('data')) {
        return _extractMap(data['data']);
      }
      return Map<String, dynamic>.from(data);
    }
    if (data is List && data.isNotEmpty) {
      return _extractMap(data.first);
    }
    return const {};
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      if (data.containsKey('results')) return _extractList(data['results']);
      if (data.containsKey('data')) return _extractList(data['data']);
      if (data.containsKey('items')) return _extractList(data['items']);
    }
    return const [];
  }

  @override
  Future<List<Evento>> getEventosActivos() async {
    try {
      print('GET: ${ApiConstants.eventosActivos}');
      final response = await dioClient.get(ApiConstants.eventosActivos);
      print('RESPONSE STATUS: ${response.statusCode}');

      final rawData = response.data;
      final list = _extractList(rawData);

      return list.map((json) => EventoModel.fromJson(json)).toList();
    } catch (e, stack) {
      print('ERROR IN getEventosActivos: $e\n$stack');
      throw ServerException('Error al obtener eventos activos: $e');
    }
  }

  @override
  Future<List<Evento>> getEventosPorCategoria(EventoCategoria categoria) async {
    try {
      final path = '${ApiConstants.eventosPorCategoria}${categoria.name}/';
      print('GET: $path');
      final response = await dioClient.get(path);
      print('RESPONSE STATUS: ${response.statusCode}');

      final rawData = response.data;
      final list = _extractList(rawData);

      return list.map((json) => EventoModel.fromJson(json)).toList();
    } catch (e, stack) {
      print('ERROR IN getEventosPorCategoria: $e\n$stack');
      throw ServerException('Error al obtener eventos por categoría: $e');
    }
  }

  @override
  Future<List<Evento>> getEventosPorFecha(DateTime fecha) async {
    try {
      final dateStr = fecha.toIso8601String();
      print('GET: ${ApiConstants.eventos}/fecha with query fecha=$dateStr');
      final response = await dioClient.get(
        '${ApiConstants.eventos}fecha/',
        queryParameters: {'fecha': dateStr},
      );
      print('RESPONSE STATUS: ${response.statusCode}');

      final rawData = response.data;
      final list = _extractList(rawData);

      return list.map((json) => EventoModel.fromJson(json)).toList();
    } catch (e, stack) {
      print('ERROR IN getEventosPorFecha: $e\n$stack');
      throw ServerException('Error al obtener eventos por fecha: $e');
    }
  }

  @override
  Future<List<Evento>> getEventosEntreFechas(
      DateTime inicio, DateTime fin) async {
    try {
      final iniStr = inicio.toIso8601String();
      final finStr = fin.toIso8601String();
      print(
          'GET: ${ApiConstants.eventos}/rango with query inicio=$iniStr, fin=$finStr');
      final response = await dioClient.get(
        '${ApiConstants.eventos}rango/',
        queryParameters: {
          'inicio': iniStr,
          'fin': finStr,
        },
      );
      print('RESPONSE STATUS: ${response.statusCode}');

      final rawData = response.data;
      final list = _extractList(rawData);

      return list.map((json) => EventoModel.fromJson(json)).toList();
    } catch (e, stack) {
      print('ERROR IN getEventosEntreFechas: $e\n$stack');
      throw ServerException('Error al obtener eventos en rango: $e');
    }
  }

  @override
  Future<Evento> getEventoPorId(String id) async {
    try {
      final path = '${ApiConstants.eventos}$id/';
      print('GET: $path');
      final response = await dioClient.get(path);
      print('RESPONSE STATUS: ${response.statusCode}');

      final rawData = response.data;
      final extracted = _extractMap(rawData);

      return EventoModel.fromJson(extracted);
    } catch (e, stack) {
      print('ERROR IN getEventoPorId: $e\n$stack');
      throw ServerException('Error al obtener evento: $e');
    }
  }

  @override
  Future<List<Evento>> buscarEventos(String query) async {
    try {
      print('GET: ${ApiConstants.eventos}/buscar with query q=$query');
      final response = await dioClient.get(
        '${ApiConstants.eventos}buscar/',
        queryParameters: {'q': query},
      );
      print('RESPONSE STATUS: ${response.statusCode}');

      final rawData = response.data;
      final list = _extractList(rawData);

      return list.map((json) => EventoModel.fromJson(json)).toList();
    } catch (e, stack) {
      print('ERROR IN buscarEventos: $e\n$stack');
      throw ServerException('Error al buscar eventos: $e');
    }
  }

  @override
  Future<void> inscribirseEvento(
      String eventoId, Map<String, dynamic> datosParticipante) async {
    try {
      final path = '${ApiConstants.eventos}$eventoId/inscripcion/';
      print('POST: $path with payload: $datosParticipante');
      final response = await dioClient.post(path, data: datosParticipante);
      print('RESPONSE STATUS: ${response.statusCode}');
    } catch (e, stack) {
      print('ERROR IN inscribirseEvento: $e\n$stack');
      throw ServerException('Error al inscribirse al evento: $e');
    }
  }

  @override
  Future<void> cancelarInscripcion(
      String eventoId, String participanteId) async {
    try {
      final path =
          '${ApiConstants.eventos}$eventoId/inscripcion/$participanteId/';
      print('DELETE: $path');
      final response = await dioClient.delete(path);
      print('RESPONSE STATUS: ${response.statusCode}');
    } catch (e, stack) {
      print('ERROR IN cancelarInscripcion: $e\n$stack');
      throw ServerException('Error al cancelar inscripción: $e');
    }
  }

  @override
  Future<List<Evento>> getTodosEventos({int page = 1, int limit = 20}) async {
    try {
      print('GET: ${ApiConstants.eventos} with page $page, limit $limit');
      final response = await dioClient.get(
        ApiConstants.eventos,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      print('RESPONSE STATUS: ${response.statusCode}');

      final rawData = response.data;
      final list = _extractList(rawData);

      return list.map((json) => EventoModel.fromJson(json)).toList();
    } catch (e, stack) {
      print('ERROR IN getTodosEventos: $e\n$stack');
      throw ServerException('Error al obtener todos los eventos: $e');
    }
  }
}
