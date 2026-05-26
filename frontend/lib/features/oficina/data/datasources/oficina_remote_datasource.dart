import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/oficina_info_model.dart';

abstract class OficinaRemoteDataSource {
  Future<OficinaInfoModel> getOficinaInfo();
}

@Injectable(as: OficinaRemoteDataSource)
class OficinaRemoteDataSourceImpl implements OficinaRemoteDataSource {
  final DioClient dioClient;

  OficinaRemoteDataSourceImpl(this.dioClient);

  @override
  Future<OficinaInfoModel> getOficinaInfo() async {
    final response = await dioClient.get(ApiConstants.oficinaInfo);
    return OficinaInfoModel.fromJson(response.data);
  }
}
