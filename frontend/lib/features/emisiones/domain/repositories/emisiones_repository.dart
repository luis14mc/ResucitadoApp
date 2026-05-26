import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/emision.dart';

/// Repository interface para emisiones
abstract class EmisionesRepository {
  /// Obtiene todas las emisiones activas
  Future<Either<Failure, List<Emision>>> getEmisionesActivas();

  /// Obtiene emisiones por categoría
  Future<Either<Failure, List<Emision>>> getEmisionesPorCategoria(
      String categoria);

  /// Obtiene emisiones en vivo
  Future<Either<Failure, List<Emision>>> getEmisionesEnVivo();

  /// Obtiene una emisión por ID
  Future<Either<Failure, Emision>> getEmisionPorId(String id);
}
