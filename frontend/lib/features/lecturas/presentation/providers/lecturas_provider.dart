import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/state/data_state.dart';
import '../../../../core/domain/usecase.dart';
import '../../../../injection.dart';
import '../../domain/entities/lectura.dart';
import '../../domain/usecases/get_lecturas_del_dia.dart';

/// Notifier para las lecturas del día
class LecturasNotifier extends StateNotifier<DataState<Lectura>> {
  final GetLecturasDelDia getLecturasDelDia;

  LecturasNotifier(this.getLecturasDelDia) : super(const DataStateInitial()) {
    loadLecturas();
  }

  /// Carga las lecturas del día
  Future<void> loadLecturas() async {
    state = const DataStateLoading();

    final result = await getLecturasDelDia(NoParams());

    result.fold(
      (failure) => state = DataStateError(failure.message),
      (lectura) => state = DataStateSuccess(lectura),
    );
  }

  /// Recarga las lecturas
  Future<void> reload() async {
    await loadLecturas();
  }
}

/// Provider para las lecturas del día
final lecturasProvider =
    StateNotifierProvider<LecturasNotifier, DataState<Lectura>>(
  (ref) => getIt<LecturasNotifier>(),
);
