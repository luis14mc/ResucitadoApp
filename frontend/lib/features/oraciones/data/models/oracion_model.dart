import '../../domain/entities/oracion.dart';
import '../../domain/entities/oracion_seccion.dart';
import 'oracion_seccion_model.dart';

class OracionModel extends Oracion {
  const OracionModel({
    required super.id,
    required super.titulo,
    required super.slug,
    required super.categoria,
    required super.descripcion,
    super.contenido,
    required super.orden,
    required super.destacada,
    required super.duracionEstimada,
    required super.secciones,
  });

  factory OracionModel.fromJson(Map<String, dynamic> json) {
    List<OracionSeccion> parsedSecciones = [];
    final secsVal = json['secciones'] ?? json['sections'];
    if (secsVal is List) {
      parsedSecciones = secsVal
          .map((e) => OracionSeccionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return OracionModel(
      id: (json['id'] ?? '').toString(),
      titulo: (json['titulo'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      categoria: (json['categoria'] ?? '').toString(),
      descripcion: (json['descripcion'] ?? '').toString(),
      contenido: json['contenido']?.toString(),
      orden: int.tryParse(json['orden']?.toString() ?? '') ?? 0,
      destacada: json['destacada'] == true || json['destacada'] == 1,
      duracionEstimada: int.tryParse(json['duracion_estimada']?.toString() ??
              json['duracionEstimada']?.toString() ??
              '') ??
          5,
      secciones: parsedSecciones,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'slug': slug,
      'categoria': categoria,
      'descripcion': descripcion,
      'contenido': contenido,
      'orden': orden,
      'destacada': destacada,
      'duracion_estimada': duracionEstimada,
      'secciones': secciones
          .map((e) => OracionSeccionModel.fromEntity(e).toJson())
          .toList(),
    };
  }

  factory OracionModel.fromEntity(Oracion entity) {
    return OracionModel(
      id: entity.id,
      titulo: entity.titulo,
      slug: entity.slug,
      categoria: entity.categoria,
      descripcion: entity.descripcion,
      contenido: entity.contenido,
      orden: entity.orden,
      destacada: entity.destacada,
      duracionEstimada: entity.duracionEstimada,
      secciones: entity.secciones,
    );
  }

  Oracion toEntity() {
    return Oracion(
      id: id,
      titulo: titulo,
      slug: slug,
      categoria: categoria,
      descripcion: descripcion,
      contenido: contenido,
      orden: orden,
      destacada: destacada,
      duracionEstimada: duracionEstimada,
      secciones: secciones,
    );
  }
}
