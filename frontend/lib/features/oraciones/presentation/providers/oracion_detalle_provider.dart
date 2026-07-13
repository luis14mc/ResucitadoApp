import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/state/data_state.dart';
import '../../domain/entities/oracion.dart';
import '../../domain/usecases/get_oracion_detalle.dart';
import '../../../../injection.dart';

/// Provider for prayer details by slug
final oracionDetalleProvider = StateNotifierProvider.family<
    OracionDetalleNotifier, DataState<Oracion>, String>((ref, slug) {
  return OracionDetalleNotifier(slug);
});

class OracionDetalleNotifier extends StateNotifier<DataState<Oracion>> {
  final String slug;

  OracionDetalleNotifier(this.slug) : super(const DataStateInitial()) {
    loadDetalle();
  }

  final GetOracionDetalle _getDetalle = getIt<GetOracionDetalle>();

  Future<void> loadDetalle() async {
    state = const DataStateLoading();
    final result = await _getDetalle(slug);
    result.fold(
      (failure) => state = DataStateError(failure.message),
      (oracion) => state = DataStateSuccess(oracion),
    );
  }
}
