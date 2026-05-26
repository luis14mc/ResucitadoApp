import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/state/data_state.dart';
import '../../../../injection.dart';
import '../../domain/entities/emision.dart';
import '../../domain/usecases/get_emisiones_activas.dart';

/// Notifier para emisiones
class EmisionesNotifier extends StateNotifier<DataState<List<Emision>>> {
  final GetEmisionesActivas getEmisionesActivas;

  EmisionesNotifier(this.getEmisionesActivas)
      : super(const DataStateInitial()) {
    loadEmisiones();
  }

  /// Carga las emisiones
  Future<void> loadEmisiones() async {
    state = const DataStateLoading();

    final result = await getEmisionesActivas();

    result.fold(
      (failure) => state = DataStateError(failure.message),
      (emisiones) => state = DataStateSuccess(emisiones),
    );
  }

  /// Recarga las emisiones
  Future<void> reload() async {
    await loadEmisiones();
  }
}

/// Provider para las emisiones
final emisionesProvider =
    StateNotifierProvider<EmisionesNotifier, DataState<List<Emision>>>(
  (ref) => getIt<EmisionesNotifier>(),
);
