import 'package:equatable/equatable.dart';

/// Entity para una emisión de video o transmisión
class Emision extends Equatable {
  final String id;
  final String titulo;
  final String descripcion;
  final String categoria;
  final String duracion;
  final DateTime fecha;
  final String thumbnail;
  final bool enVivo;
  final int vistas;
  final String? videoUrl;
  final String? youtubeId;

  const Emision({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.duracion,
    required this.fecha,
    required this.thumbnail,
    required this.enVivo,
    required this.vistas,
    this.videoUrl,
    this.youtubeId,
  });

  @override
  List<Object?> get props => [
        id,
        titulo,
        descripcion,
        categoria,
        duracion,
        fecha,
        thumbnail,
        enVivo,
        vistas,
        videoUrl,
        youtubeId,
      ];
}

/// Categorías de emisiones
enum CategoriaEmision {
  todas,
  misas,
  catequesis,
  eventos,
  testimonios,
  musica;

  String get displayName {
    switch (this) {
      case CategoriaEmision.todas:
        return 'Todas';
      case CategoriaEmision.misas:
        return 'Misas';
      case CategoriaEmision.catequesis:
        return 'Catequesis';
      case CategoriaEmision.eventos:
        return 'Eventos';
      case CategoriaEmision.testimonios:
        return 'Testimonios';
      case CategoriaEmision.musica:
        return 'Música';
    }
  }
}
