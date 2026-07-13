import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/oracion.dart';
import '../models/oracion_model.dart';
import 'oraciones_remote_datasource.dart';

class OracionesRemoteDataSourceImpl implements OracionesRemoteDataSource {
  final DioClient dioClient;

  OracionesRemoteDataSourceImpl(this.dioClient);

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
    }
    return const [];
  }

  @override
  Future<List<Oracion>> getOraciones() async {
    try {
      print('GET: ${ApiConstants.oraciones}');
      final response = await dioClient.get(ApiConstants.oraciones);
      print('RESPONSE STATUS: ${response.statusCode}');
      
      final rawData = response.data;
      final list = _extractList(rawData);
      
      return list.map((json) => OracionModel.fromJson(json).toEntity()).toList();
    } catch (e, stack) {
      print('ERROR IN getOraciones: $e\n$stack');
      throw ServerException('Error al obtener oraciones: $e');
    }
  }

  @override
  Future<List<Oracion>> getOracionesDestacadas() async {
    try {
      print('GET: ${ApiConstants.oracionesDestacadas}');
      final response = await dioClient.get(ApiConstants.oracionesDestacadas);
      print('RESPONSE STATUS: ${response.statusCode}');
      
      final rawData = response.data;
      final list = _extractList(rawData);
      
      return list.map((json) => OracionModel.fromJson(json).toEntity()).toList();
    } catch (e, stack) {
      print('ERROR IN getOracionesDestacadas: $e\n$stack');
      throw ServerException('Error al obtener oraciones destacadas: $e');
    }
  }

  @override
  Future<List<Oracion>> getOracionesPorCategoria(String categoria) async {
    try {
      final path = '${ApiConstants.oracionesCategoria}$categoria/';
      print('GET: $path');
      final response = await dioClient.get(path);
      print('RESPONSE STATUS: ${response.statusCode}');
      
      final rawData = response.data;
      final list = _extractList(rawData);
      
      return list.map((json) => OracionModel.fromJson(json).toEntity()).toList();
    } catch (e, stack) {
      print('ERROR IN getOracionesPorCategoria: $e\n$stack');
      throw ServerException('Error al obtener oraciones por categoría: $e');
    }
  }

  @override
  Future<Oracion> getOracionDetalle(String slug) async {
    try {
      final path = '${ApiConstants.oraciones}$slug/';
      print('GET: $path');
      final response = await dioClient.get(path);
      print('RESPONSE STATUS: ${response.statusCode}');
      
      final rawData = response.data;
      final extracted = _extractMap(rawData);
      
      return OracionModel.fromJson(extracted).toEntity();
    } catch (e, stack) {
      print('ERROR IN getOracionDetalle: $e\n$stack');
      throw ServerException('Error al obtener detalle de la oración: $e');
    }
  }
}
