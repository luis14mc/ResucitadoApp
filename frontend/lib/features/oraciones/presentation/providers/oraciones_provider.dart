import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/state/data_state.dart';
import '../../domain/entities/oracion.dart';
import '../../domain/usecases/get_oraciones_destacadas.dart';
import '../../domain/usecases/get_oraciones_por_categoria.dart';
import '../../../../injection.dart';

/// Provider for featured prayers
final oracionesDestacadasProvider = StateNotifierProvider<
    OracionesDestacadasNotifier, DataState<List<Oracion>>>((ref) {
  return OracionesDestacadasNotifier();
});

class OracionesDestacadasNotifier
    extends StateNotifier<DataState<List<Oracion>>> {
  OracionesDestacadasNotifier() : super(const DataStateInitial()) {
    loadDestacadas();
  }

  final GetOracionesDestacadas _getDestacadas = getIt<GetOracionesDestacadas>();

  Future<void> loadDestacadas() async {
    state = const DataStateLoading();
    final result = await _getDestacadas();
    result.fold(
      (failure) => state = DataStateError(failure.message),
      (list) => state = DataStateSuccess(list),
    );
  }
}

/// Provider for prayers by category
final oracionesCategoriaProvider = StateNotifierProvider.family<
    OracionesCategoriaNotifier,
    DataState<List<Oracion>>,
    String>((ref, categoria) {
  return OracionesCategoriaNotifier(categoria);
});

class OracionesCategoriaNotifier
    extends StateNotifier<DataState<List<Oracion>>> {
  final String categoria;

  OracionesCategoriaNotifier(this.categoria) : super(const DataStateInitial()) {
    loadPorCategoria();
  }

  final GetOracionesPorCategoria _getPorCategoria =
      getIt<GetOracionesPorCategoria>();

  Future<void> loadPorCategoria() async {
    state = const DataStateLoading();
    final result = await _getPorCategoria(categoria);
    result.fold(
      (failure) => state = DataStateError(failure.message),
      (list) {
        if (list.isEmpty) {
          state = const DataStateSuccess([]);
        } else {
          state = DataStateSuccess(list);
        }
      },
    );
  }
}
