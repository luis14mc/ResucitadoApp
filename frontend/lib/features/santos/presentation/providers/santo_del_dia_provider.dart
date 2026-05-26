import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/state/data_state.dart';
import '../../domain/entities/santo.dart';
import '../../domain/usecases/get_santo_del_dia.dart';
import '../../../../injection.dart';

/// Provider para el santo del día
///
/// Maneja el estado de la carga del santo del día usando DataState
final santoDelDiaProvider =
    StateNotifierProvider<SantoDelDiaNotifier, DataState<Santo>>((ref) {
  return SantoDelDiaNotifier();
});

/// Notifier para manejar el estado del santo del día
class SantoDelDiaNotifier extends StateNotifier<DataState<Santo>> {
  SantoDelDiaNotifier() : super(const DataStateInitial()) {
    loadSantoDelDia();
  }

  final GetSantoDelDia _getSantoDelDia = getIt<GetSantoDelDia>();

  /// Carga el santo del día actual
  Future<void> loadSantoDelDia() async {
    state = const DataStateLoading();

    final result = await _getSantoDelDia();

    result.fold(
      (failure) => state = DataStateError(failure.message),
      (santo) => state = DataStateSuccess(santo),
    );
  }

  /// Recarga el santo del día
  Future<void> reload() async {
    await loadSantoDelDia();
  }
}
