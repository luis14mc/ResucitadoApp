import '../../domain/entities/oracion.dart';

abstract class OracionesRemoteDataSource {
  Future<List<Oracion>> getOraciones();
  Future<List<Oracion>> getOracionesDestacadas();
  Future<List<Oracion>> getOracionesPorCategoria(String categoria);
  Future<Oracion> getOracionDetalle(String slug);
}
