import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/domain/usecase.dart';
import '../entities/oracion.dart';
import '../repositories/oraciones_repository.dart';

class GetOracionesPorCategoria extends UseCase<List<Oracion>, String> {
  final OracionesRepository repository;

  GetOracionesPorCategoria(this.repository);

  @override
  Future<Either<Failure, List<Oracion>>> call(String categoria) async {
    return await repository.getOracionesPorCategoria(categoria);
  }
}
