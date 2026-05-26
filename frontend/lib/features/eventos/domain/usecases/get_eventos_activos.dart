import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/domain/usecase.dart';
import '../entities/evento.dart';
import '../repositories/eventos_repository.dart';

@injectable
class GetEventosActivos extends UseCaseNoParams<List<Evento>> {
  final EventosRepository repository;

  GetEventosActivos(this.repository);

  @override
  Future<Either<Failure, List<Evento>>> call() async {
    return await repository.getEventosActivos();
  }
}
