import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/lectura.dart';

/// Repository interface para las lecturas del día
abstract class LecturasRepository {
  /// Obtiene las lecturas del día actual
  Future<Either<Failure, Lectura>> getLecturasDelDia();

  /// Obtiene las lecturas de una fecha específica
  Future<Either<Failure, Lectura>> getLecturasPorFecha(DateTime fecha);
}
