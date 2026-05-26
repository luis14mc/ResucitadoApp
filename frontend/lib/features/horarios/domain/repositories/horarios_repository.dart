import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/horario_misa.dart';

/// Repository interface para horarios de misa
abstract class HorariosRepository {
  /// Obtiene todos los horarios activos
  Future<Either<Failure, List<HorarioMisa>>> getHorariosActivos();

  /// Obtiene horarios por tipo de misa
  Future<Either<Failure, List<HorarioMisa>>> getHorariosPorTipo(TipoMisa tipo);

  /// Obtiene horarios por día de la semana
  Future<Either<Failure, List<HorarioMisa>>> getHorariosPorDia(DiaSemana dia);

  /// Obtiene un horario por ID
  Future<Either<Failure, HorarioMisa>> getHorarioPorId(String id);
}
