import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/state/data_state.dart';
import '../../domain/entities/evento.dart';
import '../../domain/usecases/get_eventos_activos.dart';
import '../../../../injection.dart';

/// Provider para los eventos activos
///
/// Maneja el estado de la carga de eventos usando DataState
final eventosProvider =
    StateNotifierProvider<EventosNotifier, DataState<List<Evento>>>((ref) {
  return EventosNotifier();
});

/// Provider para filtrar eventos por categoría
final eventosPorCategoriaProvider =
    Provider.family<List<Evento>?, EventoCategoria?>(
  (ref, categoria) {
    final eventosState = ref.watch(eventosProvider);

    if (eventosState is! DataStateSuccess<List<Evento>>) {
      return null;
    }

    if (categoria == null) {
      return eventosState.data;
    }

    return eventosState.data
        .where((evento) => evento.categoria == categoria)
        .toList();
  },
);

/// Notifier para manejar el estado de eventos
class EventosNotifier extends StateNotifier<DataState<List<Evento>>> {
  EventosNotifier() : super(const DataStateInitial()) {
    loadEventos();
  }

  final GetEventosActivos _getEventosActivos = getIt<GetEventosActivos>();

  /// Carga los eventos activos
  Future<void> loadEventos() async {
    state = const DataStateLoading();

    final result = await _getEventosActivos();

    result.fold(
      (failure) => state = DataStateError(failure.message),
      (eventos) => state = DataStateSuccess(eventos),
    );
  }

  /// Recarga los eventos
  Future<void> reload() async {
    await loadEventos();
  }
}
