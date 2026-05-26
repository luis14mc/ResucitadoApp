import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/state/data_state.dart';
import '../../domain/entities/horario_misa.dart';
import '../../domain/usecases/get_horarios_activos.dart';
import '../../../../injection.dart';

/// Provider para horarios de misa
final horariosProvider =
    StateNotifierProvider<HorariosNotifier, DataState<List<HorarioMisa>>>(
  (ref) => HorariosNotifier(getIt<GetHorariosActivos>())..loadHorarios(),
);

/// Notifier para gestionar el estado de los horarios
class HorariosNotifier extends StateNotifier<DataState<List<HorarioMisa>>> {
  final GetHorariosActivos _getHorariosActivos;

  HorariosNotifier(this._getHorariosActivos) : super(const DataStateInitial());

  /// Carga los horarios de misa
  Future<void> loadHorarios() async {
    state = const DataStateLoading();

    final result = await _getHorariosActivos();

    result.fold(
      (failure) => state = DataStateError(failure.message),
      (horarios) => state = DataStateSuccess(horarios),
    );
  }

  /// Recarga los horarios
  Future<void> reload() async {
    await loadHorarios();
  }
}
