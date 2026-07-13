import 'package:equatable/equatable.dart';
import 'oracion_seccion.dart';

class Oracion extends Equatable {
  final String id;
  final String titulo;
  final String slug;
  final String categoria;
  final String descripcion;
  final String? contenido;
  final int orden;
  final bool destacada;
  final int duracionEstimada;
  final List<OracionSeccion> secciones;

  const Oracion({
    required this.id,
    required this.titulo,
    required this.slug,
    required this.categoria,
    required this.descripcion,
    this.contenido,
    required this.orden,
    required this.destacada,
    required this.duracionEstimada,
    required this.secciones,
  });

  @override
  List<Object?> get props => [
        id,
        titulo,
        slug,
        categoria,
        descripcion,
        contenido,
        orden,
        destacada,
        duracionEstimada,
        secciones,
      ];
}
