import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/oficina_info_model.dart';

abstract class OficinaRemoteDataSource {
  Future<OficinaInfoModel> getOficinaInfo();
}

@Injectable(as: OficinaRemoteDataSource)
class OficinaRemoteDataSourceImpl implements OficinaRemoteDataSource {
  final DioClient dioClient;

  OficinaRemoteDataSourceImpl(this.dioClient);

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

  @override
  Future<OficinaInfoModel> getOficinaInfo() async {
    try {
      print('GET: /oficina/info');
      final response = await dioClient.get(ApiConstants.oficinaInfo);
      print('RESPONSE STATUS: ${response.statusCode}');

      final rawData = response.data;
      final extracted = _extractMap(rawData);

      return OficinaInfoModel.fromJson(extracted);
    } catch (e, stack) {
      print('ERROR IN getOficinaInfo: $e\n$stack');
      throw ServerException('Error al obtener info de la oficina: $e');
    }
  }
}
