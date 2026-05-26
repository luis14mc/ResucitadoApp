import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/emision_model.dart';

/// Remote data source para emisiones.
/// v2: apunta al backend Django (core_liturgia.VideoMisa).
abstract class EmisionesRemoteDataSource {
  Future<List<EmisionModel>> getEmisionesActivas();
  Future<List<EmisionModel>> getEmisionesPorCategoria(String categoria);
  Future<List<EmisionModel>> getEmisionesEnVivo();
  Future<EmisionModel> getEmisionPorId(String id);
}

List<dynamic> _unwrap(dynamic raw) {
  if (raw is List) return raw;
  if (raw is Map) return (raw['results'] ?? raw['data'] ?? []) as List;
  return const [];
}

@Injectable(as: EmisionesRemoteDataSource)
class EmisionesRemoteDataSourceImpl implements EmisionesRemoteDataSource {
  final DioClient dioClient;

  EmisionesRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<EmisionModel>> getEmisionesActivas() async {
    final response = await dioClient.get(ApiConstants.emisiones);
    return _unwrap(response.data)
        .map((json) => EmisionModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<EmisionModel>> getEmisionesPorCategoria(String categoria) async {
    final response = await dioClient.get(
      '${ApiConstants.emisiones}categoria/$categoria/',
    );
    return _unwrap(response.data)
        .map((json) => EmisionModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<EmisionModel>> getEmisionesEnVivo() async {
    final response = await dioClient.get(ApiConstants.emisionesEnVivo);
    return _unwrap(response.data)
        .map((json) => EmisionModel.fromJson(json))
        .toList();
  }

  @override
  Future<EmisionModel> getEmisionPorId(String id) async {
    final response = await dioClient.get('${ApiConstants.emisiones}$id/');
    return EmisionModel.fromJson(response.data);
  }
}
