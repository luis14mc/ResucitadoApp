import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/domain/usecase.dart';
import '../entities/santo.dart';
import '../repositories/santos_repository.dart';

@injectable
class GetSantoDelDia extends UseCaseNoParams<Santo> {
  final SantosRepository repository;

  GetSantoDelDia(this.repository);

  @override
  Future<Either<Failure, Santo>> call() async {
    return await repository.getSantoDelDia();
  }
}
