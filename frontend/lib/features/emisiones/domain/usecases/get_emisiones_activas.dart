import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/emision.dart';
import '../repositories/emisiones_repository.dart';

/// UseCase para obtener emisiones activas
class GetEmisionesActivas {
  final EmisionesRepository repository;

  GetEmisionesActivas(this.repository);

  Future<Either<Failure, List<Emision>>> call() async {
    return await repository.getEmisionesActivas();
  }
}
