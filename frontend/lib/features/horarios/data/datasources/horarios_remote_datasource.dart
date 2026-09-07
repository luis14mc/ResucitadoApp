import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/horario_misa_model.dart';

/// Remote data source para horarios de misa
abstract class HorariosRemoteDataSource {
  Future<List<HorarioMisaModel>> getHorariosActivos();
  Future<List<HorarioMisaModel>> getHorariosPorTipo(String tipo);
  Future<List<HorarioMisaModel>> getHorariosPorDia(String dia);
  Future<HorarioMisaModel> getHorarioPorId(String id);
}

@LazySingleton(as: HorariosRemoteDataSource)
class HorariosRemoteDataSourceImpl implements HorariosRemoteDataSource {
  final DioClient dioClient;

  HorariosRemoteDataSourceImpl(this.dioClient);

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
  Future<List<HorarioMisaModel>> getHorariosActivos() async {
    try {
      print('GET: /horarios-misa');
      final response = await dioClient.get(ApiConstants.horarios);
      print('RESPONSE STATUS: ${response.statusCode}');

      final rawData = response.data;
      final list = _extractList(rawData);

      return list.map((json) => HorarioMisaModel.fromJson(json)).toList();
    } catch (e, stack) {
      print('ERROR IN getHorariosActivos: $e\n$stack');
      throw ServerException('Error al obtener horarios de misa: $e');
    }
  }

  @override
  Future<List<HorarioMisaModel>> getHorariosPorTipo(String tipo) async {
    final all = await getHorariosActivos();
    return all
        .where((h) => h.tipo.name.toLowerCase() == tipo.toLowerCase())
        .toList();
  }

  @override
  Future<List<HorarioMisaModel>> getHorariosPorDia(String dia) async {
    final normalized = dia.toLowerCase();
    final all = await getHorariosActivos();
    return all.where((h) {
      final value = h.dia;
      return value != null &&
          (value.displayName.toLowerCase() == normalized ||
              value.name.toLowerCase() == normalized);
    }).toList();
  }

  @override
  Future<HorarioMisaModel> getHorarioPorId(String id) async {
    try {
      print('GET: /horarios-misa/$id');
      final response = await dioClient.get('\${ApiConstants.horarios}$id/');
      print('RESPONSE STATUS: ${response.statusCode}');

      final rawData = response.data;
      final extracted = _extractMap(rawData);

      return HorarioMisaModel.fromJson(extracted);
    } catch (e, stack) {
      print(
          'WARNING/ERROR in getHorarioPorId: $e. Falling back to client-side search.');
      try {
        final all = await getHorariosActivos();
        return all.firstWhere((h) => h.id == id);
      } catch (fallbackErr) {
        print('FALLBACK FAILED: $fallbackErr');
        throw ServerException('Error al obtener horario: $e');
      }
    }
  }
}
