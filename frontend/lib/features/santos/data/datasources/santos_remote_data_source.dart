import '../../domain/entities/santo.dart';

abstract class SantosRemoteDataSource {
  Future<Santo> getSantoDelDia();
  Future<List<Santo>> getSantosPorMes(int mes);
  Future<List<Santo>> getSantosPorFecha(DateTime fecha);
  Future<List<Santo>> buscarSantos(String query);
  Future<Santo> getSantoPorId(String id);
  Future<List<Santo>> getTodosSantos({int page = 1, int limit = 20});
}
