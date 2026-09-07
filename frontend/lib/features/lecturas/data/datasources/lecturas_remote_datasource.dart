import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/lectura_model.dart';

/// Remote data source para las lecturas del día
abstract class LecturasRemoteDataSource {
  /// Obtiene las lecturas del día actual desde el API
  Future<LecturaModel> getLecturasDelDia();

  /// Obtiene las lecturas de una fecha específica
  Future<LecturaModel> getLecturasPorFecha(DateTime fecha);
}

@Injectable(as: LecturasRemoteDataSource)
class LecturasRemoteDataSourceImpl implements LecturasRemoteDataSource {
  final DioClient dioClient;

  LecturasRemoteDataSourceImpl(this.dioClient);

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
  Future<LecturaModel> getLecturasDelDia() async {
    try {
      print('GET: /lecturas/hoy');
      final response = await dioClient.get(ApiConstants.lecturasHoy);
      print('RESPONSE STATUS: ${response.statusCode}');

      final rawData = response.data;
      final extracted = _extractMap(rawData);

      return LecturaModel.fromJson(extracted);
    } catch (e, stack) {
      print('ERROR IN getLecturasDelDia: $e\n$stack');
      throw ServerException('Error al obtener lecturas del día: $e');
    }
  }

  @override
  Future<LecturaModel> getLecturasPorFecha(DateTime fecha) async {
    try {
      final formattedDate = fecha.toIso8601String().split('T')[0];
      print('GET: /lecturas with query fecha=$formattedDate');
      final response = await dioClient.get(
        ApiConstants.lecturasPorFecha(formattedDate),
      );
      print('RESPONSE STATUS: ${response.statusCode}');

      final rawData = response.data;
      final extracted = _extractMap(rawData);

      return LecturaModel.fromJson(extracted);
    } catch (e, stack) {
      print('ERROR IN getLecturasPorFecha: $e\n$stack');
      throw ServerException('Error al obtener lecturas por fecha: $e');
    }
  }
}
