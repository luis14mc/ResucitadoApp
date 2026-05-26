import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/parroquia_info.dart';
import '../repositories/parroquia_repository.dart';

/// UseCase para obtener información de la parroquia
class GetParroquiaInfo {
  final ParroquiaRepository repository;

  GetParroquiaInfo(this.repository);

  Future<Either<Failure, ParroquiaInfo>> call() async {
    return await repository.getParroquiaInfo();
  }
}
