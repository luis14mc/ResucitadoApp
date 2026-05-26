import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/state/data_state.dart';
import '../../../../injection.dart';
import '../../domain/entities/oficina_info.dart';
import '../../domain/usecases/get_oficina_info.dart';

class OficinaNotifier extends StateNotifier<DataState<OficinaInfo>> {
  final GetOficinaInfo getOficinaInfo;

  OficinaNotifier(this.getOficinaInfo) : super(const DataStateInitial()) {
    loadInfo();
  }

  Future<void> loadInfo() async {
    state = const DataStateLoading();
    final result = await getOficinaInfo();
    result.fold(
      (failure) => state = DataStateError(failure.message),
      (info) => state = DataStateSuccess(info),
    );
  }

  Future<void> reload() async => await loadInfo();
}

final oficinaProvider =
    StateNotifierProvider<OficinaNotifier, DataState<OficinaInfo>>(
  (ref) => getIt<OficinaNotifier>(),
);
