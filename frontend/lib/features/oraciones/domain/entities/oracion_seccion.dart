import 'package:equatable/equatable.dart';

class OracionSeccion extends Equatable {
  final String id;
  final String titulo;
  final String contenido;
  final int orden;

  const OracionSeccion({
    required this.id,
    required this.titulo,
    required this.contenido,
    required this.orden,
  });

  @override
  List<Object?> get props => [id, titulo, contenido, orden];
}
