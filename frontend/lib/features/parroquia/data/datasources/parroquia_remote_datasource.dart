import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/parroquia_info_model.dart';

/// Remote data source para información de la parroquia
abstract class ParroquiaRemoteDataSource {
  Future<ParroquiaInfoModel> getParroquiaInfo();
}

@Injectable(as: ParroquiaRemoteDataSource)
class ParroquiaRemoteDataSourceImpl implements ParroquiaRemoteDataSource {
  final DioClient dioClient;

  ParroquiaRemoteDataSourceImpl(this.dioClient);

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
  Future<ParroquiaInfoModel> getParroquiaInfo() async {
    try {
      print('GET: /parroquia/info');
      final response = await dioClient.get('/parroquia/info');
      print('RESPONSE STATUS: ${response.statusCode}');
      
      final rawData = response.data;
      final extracted = _extractMap(rawData);
      
      return ParroquiaInfoModel.fromJson(extracted);
    } catch (e, stack) {
      print('ERROR IN getParroquiaInfo: $e\n$stack');
      throw ServerException('Error al obtener info de la parroquia: $e');
    }
  }
}
