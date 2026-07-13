import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/domain/usecase.dart';
import '../entities/oracion.dart';
import '../repositories/oraciones_repository.dart';

class GetOracionDetalle extends UseCase<Oracion, String> {
  final OracionesRepository repository;

  GetOracionDetalle(this.repository);

  @override
  Future<Either<Failure, Oracion>> call(String slug) async {
    return await repository.getOracionDetalle(slug);
  }
}
