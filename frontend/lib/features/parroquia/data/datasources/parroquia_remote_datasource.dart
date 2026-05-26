import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/parroquia_info_model.dart';

/// Remote data source para información de la parroquia
abstract class ParroquiaRemoteDataSource {
  Future<ParroquiaInfoModel> getParroquiaInfo();
}

@Injectable(as: ParroquiaRemoteDataSource)
class ParroquiaRemoteDataSourceImpl implements ParroquiaRemoteDataSource {
  final DioClient dioClient;

  ParroquiaRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ParroquiaInfoModel> getParroquiaInfo() async {
    final response = await dioClient.get(ApiConstants.parroquiaInfo);
    return ParroquiaInfoModel.fromJson(response.data);
  }
}
