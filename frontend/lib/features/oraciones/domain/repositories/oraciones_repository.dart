import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/oracion.dart';

abstract class OracionesRepository {
  Future<Either<Failure, List<Oracion>>> getOraciones();
  Future<Either<Failure, List<Oracion>>> getOracionesDestacadas();
  Future<Either<Failure, List<Oracion>>> getOracionesPorCategoria(
      String categoria);
  Future<Either<Failure, Oracion>> getOracionDetalle(String slug);
}
