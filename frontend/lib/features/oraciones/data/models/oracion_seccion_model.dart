import '../../domain/entities/oracion_seccion.dart';

class OracionSeccionModel extends OracionSeccion {
  const OracionSeccionModel({
    required super.id,
    required super.titulo,
    required super.contenido,
    required super.orden,
  });

  factory OracionSeccionModel.fromJson(Map<String, dynamic> json) {
    return OracionSeccionModel(
      id: (json['id'] ?? json['idSeccion'] ?? '').toString(),
      titulo: (json['titulo'] ?? '').toString(),
      contenido: (json['contenido'] ?? '').toString(),
      orden: int.tryParse(json['orden']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'contenido': contenido,
      'orden': orden,
    };
  }

  factory OracionSeccionModel.fromEntity(OracionSeccion entity) {
    return OracionSeccionModel(
      id: entity.id,
      titulo: entity.titulo,
      contenido: entity.contenido,
      orden: entity.orden,
    );
  }
}
