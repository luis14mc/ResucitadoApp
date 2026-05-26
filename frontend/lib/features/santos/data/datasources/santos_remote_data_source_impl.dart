import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/santo.dart';
import '../models/santo_model.dart';
import 'santos_remote_data_source.dart';

@LazySingleton(as: SantosRemoteDataSource)
class SantosRemoteDataSourceImpl implements SantosRemoteDataSource {
  final DioClient dioClient;

  SantosRemoteDataSourceImpl(this.dioClient);

  @override
  Future<Santo> getSantoDelDia() async {
    try {
      final response = await dioClient.get(ApiConstants.santoDelDia);

      if (response.statusCode == 200) {
        final json = response.data['data'] ?? response.data;
        final santoModel = SantoModel.fromJson(json);
        return santoModel.toEntity();
      } else {
        throw ServerException('Error al obtener santo del día',
            statusCode: response.statusCode);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Error inesperado: $e');
    }
  }

  @override
  Future<List<Santo>> getSantosPorMes(int mes) async {
    try {
      final response = await dioClient.get(
        ApiConstants.santosPorMes,
        queryParameters: {'mes': mes},
      );

      if (response.statusCode == 200) {
        final List<dynamic> santosData = response.data['data'] ?? response.data;
        return santosData
            .map((json) => SantoModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw ServerException('Error al obtener santos del mes',
            statusCode: response.statusCode);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Error inesperado: $e');
    }
  }

  @override
  Future<List<Santo>> getSantosPorFecha(DateTime fecha) async {
    try {
      final response = await dioClient.get(
        ApiConstants.santos,
        queryParameters: {
          'fecha': fecha.toIso8601String().split('T')[0],
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> santosData = response.data['data'] ?? response.data;
        return santosData
            .map((json) => SantoModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw ServerException('Error al obtener santos por fecha',
            statusCode: response.statusCode);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Error inesperado: $e');
    }
  }

  @override
  Future<List<Santo>> buscarSantos(String query) async {
    try {
      final response = await dioClient.get(
        ApiConstants.santos,
        queryParameters: {'search': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> santosData = response.data['data'] ?? response.data;
        return santosData
            .map((json) => SantoModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw ServerException('Error al buscar santos',
            statusCode: response.statusCode);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Error inesperado: $e');
    }
  }

  @override
  Future<Santo> getSantoPorId(String id) async {
    try {
      final response = await dioClient.get('${ApiConstants.santos}/$id');

      if (response.statusCode == 200) {
        final json = response.data['data'] ?? response.data;
        final santoModel = SantoModel.fromJson(json);
        return santoModel.toEntity();
      } else {
        throw ServerException('Error al obtener santo',
            statusCode: response.statusCode);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Error inesperado: $e');
    }
  }

  @override
  Future<List<Santo>> getTodosSantos({int page = 1, int limit = 20}) async {
    try {
      final response = await dioClient.get(
        ApiConstants.santos,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> santosData = response.data['data'] ?? response.data;
        return santosData
            .map((json) => SantoModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw ServerException('Error al obtener todos los santos',
            statusCode: response.statusCode);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Error inesperado: $e');
    }
  }
}
