import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/state/data_state.dart';
import '../../../../injection.dart';
import '../../domain/entities/parroquia_info.dart';
import '../../domain/usecases/get_parroquia_info.dart';

/// Notifier para información de la parroquia
class ParroquiaNotifier extends StateNotifier<DataState<ParroquiaInfo>> {
  final GetParroquiaInfo getParroquiaInfo;

  ParroquiaNotifier(this.getParroquiaInfo) : super(const DataStateInitial()) {
    loadInfo();
  }

  Future<void> loadInfo() async {
    state = const DataStateLoading();

    final result = await getParroquiaInfo();

    result.fold(
      (failure) => state = DataStateError(failure.message),
      (info) => state = DataStateSuccess(info),
    );
  }

  Future<void> reload() async {
    await loadInfo();
  }
}

/// Provider para información de la parroquia
final parroquiaProvider =
    StateNotifierProvider<ParroquiaNotifier, DataState<ParroquiaInfo>>(
  (ref) => getIt<ParroquiaNotifier>(),
);
