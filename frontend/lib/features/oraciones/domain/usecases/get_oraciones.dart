import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/domain/usecase.dart';
import '../entities/oracion.dart';
import '../repositories/oraciones_repository.dart';

class GetOraciones extends UseCaseNoParams<List<Oracion>> {
  final OracionesRepository repository;

  GetOraciones(this.repository);

  @override
  Future<Either<Failure, List<Oracion>>> call() async {
    return await repository.getOraciones();
  }
}
