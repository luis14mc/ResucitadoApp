import 'package:equatable/equatable.dart';

/// Estados base para manejo de estados en la UI
///
/// Usa sealed class para garantizar exhaustividad en pattern matching
///
/// Ejemplo de uso:
/// ```dart
/// class SantoState extends DataState<Santo> {}
///
/// // En el provider:
/// DataState<Santo> state = DataStateInitial();
/// state = DataStateLoading();
/// state = DataStateSuccess(santo);
/// state = DataStateError('Error al cargar santo');
///
/// // En la UI:
/// switch (state) {
///   case DataStateInitial():
///     return Text('Inicial');
///   case DataStateLoading():
///     return CircularProgressIndicator();
///   case DataStateSuccess(data: final santo):
///     return SantoCard(santo: santo);
///   case DataStateError(message: final error):
///     return ErrorWidget(message: error);
/// }
/// ```
sealed class DataState<T> extends Equatable {
  const DataState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial - ninguna acción ha sido realizada aún
class DataStateInitial<T> extends DataState<T> {
  const DataStateInitial();
}

/// Estado de carga - esperando respuesta
class DataStateLoading<T> extends DataState<T> {
  const DataStateLoading();
}

/// Estado de éxito - datos cargados correctamente
class DataStateSuccess<T> extends DataState<T> {
  final T data;

  const DataStateSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

/// Estado de error - algo salió mal
class DataStateError<T> extends DataState<T> {
  final String message;

  const DataStateError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Extension methods para facilitar el uso
extension DataStateExtension<T> on DataState<T> {
  /// Retorna true si el estado es inicial
  bool get isInitial => this is DataStateInitial<T>;

  /// Retorna true si el estado es loading
  bool get isLoading => this is DataStateLoading<T>;

  /// Retorna true si el estado es success
  bool get isSuccess => this is DataStateSuccess<T>;

  /// Retorna true si el estado es error
  bool get isError => this is DataStateError<T>;

  /// Retorna los datos si el estado es success, null en otro caso
  T? get dataOrNull =>
      this is DataStateSuccess<T> ? (this as DataStateSuccess<T>).data : null;

  /// Retorna el mensaje de error si el estado es error, null en otro caso
  String? get errorOrNull =>
      this is DataStateError<T> ? (this as DataStateError<T>).message : null;
}
