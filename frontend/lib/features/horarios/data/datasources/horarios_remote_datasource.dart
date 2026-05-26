import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/horario_misa_model.dart';

/// Remote data source para horarios de misa.
/// v2: apunta al backend Django (core_liturgia.MisaHorario).
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

  @override
  Future<List<HorarioMisaModel>> getHorariosActivos() async {
    try {
      // Canónico v2: /horarios/  (Django también expone /horarios-misa/ legacy)
      final response = await dioClient.get(ApiConstants.horarios);
      final raw = response.data;
      // DRF paginado devuelve {results: [...]}; lista plana también soportada.
      final List<dynamic> data =
          (raw is Map ? (raw['results'] ?? raw['data']) : raw) ?? [];
      return data.map((json) => HorarioMisaModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Error al obtener horarios de misa: $e');
    }
  }

  @override
  Future<List<HorarioMisaModel>> getHorariosPorTipo(String tipo) async {
    try {
      final response = await dioClient.get(
        '${ApiConstants.horarios}tipo/$tipo/',
      );
      final raw = response.data;
      final List<dynamic> data =
          (raw is Map ? (raw['results'] ?? raw['data']) : raw) ?? [];
      return data.map((json) => HorarioMisaModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Error al obtener horarios por tipo: $e');
    }
  }

  @override
  Future<List<HorarioMisaModel>> getHorariosPorDia(String dia) async {
    try {
      final response = await dioClient.get(
        '${ApiConstants.horarios}dia/$dia/',
      );
      final raw = response.data;
      final List<dynamic> data =
          (raw is Map ? (raw['results'] ?? raw['data']) : raw) ?? [];
      return data.map((json) => HorarioMisaModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Error al obtener horarios por día: $e');
    }
  }

  @override
  Future<HorarioMisaModel> getHorarioPorId(String id) async {
    try {
      final response = await dioClient.get('${ApiConstants.horarios}$id/');
      final raw = response.data;
      return HorarioMisaModel.fromJson(raw is Map ? (raw['data'] ?? raw) : raw);
    } catch (e) {
      throw ServerException('Error al obtener horario: $e');
    }
  }
}
