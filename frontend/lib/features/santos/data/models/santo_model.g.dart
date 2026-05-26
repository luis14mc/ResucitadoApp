// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'santo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SantoModel _$SantoModelFromJson(Map<String, dynamic> json) => SantoModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      titulo: json['titulo'] as String,
      fechaCelebracion: DateTime.parse(json['fecha_celebracion'] as String),
      biografia: json['biografia'] as String,
      festividad: json['festividad'] as String,
      patrono: json['patrono'] as String,
      oracion: json['oracion'] as String,
      imagenUrl: json['imagen_url'] as String?,
      atributos:
          (json['atributos'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$SantoModelToJson(SantoModel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'nombre': instance.nombre,
    'titulo': instance.titulo,
    'fecha_celebracion': instance.fechaCelebracion.toIso8601String(),
    'biografia': instance.biografia,
    'festividad': instance.festividad,
    'patrono': instance.patrono,
    'oracion': instance.oracion,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('imagen_url', instance.imagenUrl);
  val['atributos'] = instance.atributos;
  val['created_at'] = instance.createdAt.toIso8601String();
  val['updated_at'] = instance.updatedAt.toIso8601String();
  return val;
}
