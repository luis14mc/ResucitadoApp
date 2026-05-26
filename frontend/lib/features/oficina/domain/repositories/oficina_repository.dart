import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/oficina_info.dart';

abstract class OficinaRepository {
  Future<Either<Failure, OficinaInfo>> getOficinaInfo();
}
