import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/horario_misa.dart';
import '../repositories/horarios_repository.dart';

/// UseCase para obtener todos los horarios de misa activos
class GetHorariosActivos {
  final HorariosRepository repository;

  GetHorariosActivos(this.repository);

  Future<Either<Failure, List<HorarioMisa>>> call() async {
    return await repository.getHorariosActivos();
  }
}
