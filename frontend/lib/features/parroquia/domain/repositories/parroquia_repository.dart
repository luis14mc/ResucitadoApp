import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/parroquia_info.dart';

/// Repository interface para información de la parroquia
abstract class ParroquiaRepository {
  /// Obtiene la información de la parroquia
  Future<Either<Failure, ParroquiaInfo>> getParroquiaInfo();
}
