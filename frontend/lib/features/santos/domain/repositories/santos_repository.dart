import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/santo.dart';

abstract class SantosRepository {
  Future<Either<Failure, Santo>> getSantoDelDia();
  Future<Either<Failure, List<Santo>>> getSantosPorMes(int mes);
  Future<Either<Failure, List<Santo>>> getSantosPorFecha(DateTime fecha);
  Future<Either<Failure, List<Santo>>> buscarSantos(String query);
  Future<Either<Failure, Santo>> getSantoPorId(String id);
  Future<Either<Failure, List<Santo>>> getTodosSantos({
    int page = 1,
    int limit = 20,
  });
}
