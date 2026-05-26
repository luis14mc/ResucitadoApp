import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/oficina_info.dart';
import '../repositories/oficina_repository.dart';

class GetOficinaInfo {
  final OficinaRepository repository;

  GetOficinaInfo(this.repository);

  Future<Either<Failure, OficinaInfo>> call() async {
    return await repository.getOficinaInfo();
  }
}
