import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/santo.dart';
import '../models/santo_model.dart';
import 'santos_remote_data_source.dart';

@LazySingleton(as: SantosRemoteDataSource)
class SantosRemoteDataSourceImpl implements SantosRemoteDataSource {
  final DioClient dioClient;

  SantosRemoteDataSourceImpl(this.dioClient);

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
  Future<Santo> getSantoDelDia() async {
    try {
      print('GET: ${ApiConstants.santoDelDia}');
      final response = await dioClient.get(ApiConstants.santoDelDia);
      print('RESPONSE STATUS: ${response.statusCode}');

      final rawData = response.data;
      final extracted = _extractMap(rawData);

      return SantoModel.fromJson(extracted).toEntity();
    } catch (e, stack) {
      print('ERROR IN getSantoDelDia: $e\n$stack');
      throw ServerException('Error al obtener santo del día: $e');
    }
  }

  @override
  Future<List<Santo>> getSantosPorMes(int mes) async {
    try {
      final path = '${ApiConstants.santosPorMes}';
      print('GET: $path');
      final response = await dioClient.get(
        path,
        queryParameters: {'mes': mes},
      );
      print('RESPONSE STATUS: ${response.statusCode}');

      final rawData = response.data;
      final list = _extractList(rawData);

      return list.map((json) => SantoModel.fromJson(json).toEntity()).toList();
    } catch (e, stack) {
      print('ERROR IN getSantosPorMes: $e\n$stack');
      throw ServerException('Error al obtener santos del mes: $e');
    }
  }

  @override
  Future<List<Santo>> getSantosPorFecha(DateTime fecha) async {
    try {
      final formattedDate = fecha.toIso8601String().split('T')[0];
      print('GET: ${ApiConstants.santos} with date query $formattedDate');
      final response = await dioClient.get(
        ApiConstants.santos,
        queryParameters: {'fecha': formattedDate},
      );
      print('RESPONSE STATUS: ${response.statusCode}');

      final rawData = response.data;
      final list = _extractList(rawData);

      return list.map((json) => SantoModel.fromJson(json).toEntity()).toList();
    } catch (e, stack) {
      print('ERROR IN getSantosPorFecha: $e\n$stack');
      throw ServerException('Error al obtener santos por fecha: $e');
    }
  }

  @override
  Future<List<Santo>> buscarSantos(String query) async {
    try {
      print('GET: ${ApiConstants.santos} with search query $query');
      final response = await dioClient.get(
        ApiConstants.santos,
        queryParameters: {'search': query},
      );
      print('RESPONSE STATUS: ${response.statusCode}');

      final rawData = response.data;
      final list = _extractList(rawData);

      return list.map((json) => SantoModel.fromJson(json).toEntity()).toList();
    } catch (e, stack) {
      print('ERROR IN buscarSantos: $e\n$stack');
      throw ServerException('Error al buscar santos: $e');
    }
  }

  @override
  Future<Santo> getSantoPorId(String id) async {
    try {
      final path = '${ApiConstants.santos}$id/';
      print('GET: $path');
      final response = await dioClient.get(path);
      print('RESPONSE STATUS: ${response.statusCode}');

      final rawData = response.data;
      final extracted = _extractMap(rawData);

      return SantoModel.fromJson(extracted).toEntity();
    } catch (e, stack) {
      print('ERROR IN getSantoPorId: $e\n$stack');
      throw ServerException('Error al obtener santo por id: $e');
    }
  }

  @override
  Future<List<Santo>> getTodosSantos({int page = 1, int limit = 20}) async {
    try {
      print('GET: ${ApiConstants.santos} with page $page, limit $limit');
      final response = await dioClient.get(
        ApiConstants.santos,
        queryParameters: {'page': page, 'limit': limit},
      );
      print('RESPONSE STATUS: ${response.statusCode}');

      final rawData = response.data;
      final list = _extractList(rawData);

      return list.map((json) => SantoModel.fromJson(json).toEntity()).toList();
    } catch (e, stack) {
      print('ERROR IN getTodosSantos: $e\n$stack');
      throw ServerException('Error al obtener todos los santos: $e');
    }
  }
}
