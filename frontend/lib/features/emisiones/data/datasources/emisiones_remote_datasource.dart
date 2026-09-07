import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/emision_model.dart';

/// Remote data source para emisiones
abstract class EmisionesRemoteDataSource {
  Future<List<EmisionModel>> getEmisionesActivas();
  Future<List<EmisionModel>> getEmisionesPorCategoria(String categoria);
  Future<List<EmisionModel>> getEmisionesEnVivo();
  Future<EmisionModel> getEmisionPorId(String id);
}

@Injectable(as: EmisionesRemoteDataSource)
class EmisionesRemoteDataSourceImpl implements EmisionesRemoteDataSource {
  final DioClient dioClient;

  EmisionesRemoteDataSourceImpl(this.dioClient);

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
  Future<List<EmisionModel>> getEmisionesActivas() async {
    try {
      print('GET: /emisiones');
      final response = await dioClient.get(ApiConstants.emisiones);
      print('RESPONSE STATUS: ${response.statusCode}');

      final rawData = response.data;
      final list = _extractList(rawData);

      return list.map((json) => EmisionModel.fromJson(json)).toList();
    } catch (e, stack) {
      print('ERROR IN getEmisionesActivas: $e\n$stack');
      throw ServerException('Error al obtener emisiones activas: $e');
    }
  }

  @override
  Future<List<EmisionModel>> getEmisionesPorCategoria(String categoria) async {
    final all = await getEmisionesActivas();
    return all
        .where(
            (item) => item.categoria.toLowerCase() == categoria.toLowerCase())
        .toList();
  }

  @override
  Future<List<EmisionModel>> getEmisionesEnVivo() async {
    try {
      print('GET: /emisiones/en-vivo');
      final response = await dioClient.get(ApiConstants.emisionesEnVivo);
      print('RESPONSE STATUS: ${response.statusCode}');

      final rawData = response.data;
      final list = _extractList(rawData);

      return list.map((json) => EmisionModel.fromJson(json)).toList();
    } catch (e, stack) {
      print('ERROR IN getEmisionesEnVivo: $e\n$stack');
      throw ServerException('Error al obtener emisiones en vivo: $e');
    }
  }

  @override
  Future<EmisionModel> getEmisionPorId(String id) async {
    try {
      print('GET: /emisiones/$id');
      final response = await dioClient.get('\${ApiConstants.emisiones}$id/');
      print('RESPONSE STATUS: ${response.statusCode}');

      final rawData = response.data;
      final extracted = _extractMap(rawData);

      return EmisionModel.fromJson(extracted);
    } catch (e, stack) {
      print('ERROR IN getEmisionPorId: $e\n$stack');
      throw ServerException('Error al obtener emisión por id: $e');
    }
  }
}
