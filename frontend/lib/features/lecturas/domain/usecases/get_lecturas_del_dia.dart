import 'package:dartz/dartz.dart';
import '../../../../core/domain/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../entities/lectura.dart';
import '../repositories/lecturas_repository.dart';

/// UseCase para obtener las lecturas del día actual
class GetLecturasDelDia implements UseCase<Lectura, NoParams> {
  final LecturasRepository repository;

  GetLecturasDelDia(this.repository);

  @override
  Future<Either<Failure, Lectura>> call(NoParams params) async {
    return await repository.getLecturasDelDia();
  }
}
