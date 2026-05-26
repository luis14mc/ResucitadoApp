import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/lectura_model.dart';

/// Remote data source para las lecturas del día.
/// v2: apunta al backend Django (core_liturgia.CalendarioLiturgico).
abstract class LecturasRemoteDataSource {
  Future<LecturaModel> getLecturasDelDia();
  Future<LecturaModel> getLecturasPorFecha(DateTime fecha);
}

class LecturasRemoteDataSourceImpl implements LecturasRemoteDataSource {
  final DioClient dioClient;

  LecturasRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<LecturaModel> getLecturasDelDia() async {
    try {
      // Endpoint canónico v2: /calendario/hoy/
      // (Django también expone alias /lecturas/hoy/ por compat.)
      final response = await dioClient.get(ApiConstants.lecturasHoy);
      return LecturaModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Error al obtener lecturas del día: ${e.message}');
    }
  }

  @override
  Future<LecturaModel> getLecturasPorFecha(DateTime fecha) async {
    try {
      final formattedDate = fecha.toIso8601String().split('T')[0];
      final response = await dioClient.get(
        ApiConstants.lecturasPorFecha(formattedDate),
      );
      return LecturaModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Error al obtener lecturas: ${e.message}');
    }
  }
}
