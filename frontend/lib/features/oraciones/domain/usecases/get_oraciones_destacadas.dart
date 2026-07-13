import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/domain/usecase.dart';
import '../entities/oracion.dart';
import '../repositories/oraciones_repository.dart';

class GetOracionesDestacadas extends UseCaseNoParams<List<Oracion>> {
  final OracionesRepository repository;

  GetOracionesDestacadas(this.repository);

  @override
  Future<Either<Failure, List<Oracion>>> call() async {
    return await repository.getOracionesDestacadas();
  }
}
