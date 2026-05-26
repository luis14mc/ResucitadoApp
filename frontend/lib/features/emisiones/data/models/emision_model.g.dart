// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emision_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmisionModel _$EmisionModelFromJson(Map<String, dynamic> json) => EmisionModel(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String,
      categoria: json['categoria'] as String,
      duracion: json['duracion'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
      thumbnail: json['thumbnail'] as String,
      enVivo: json['en_vivo'] as bool,
      vistas: (json['vistas'] as num).toInt(),
      videoUrl: json['video_url'] as String?,
      youtubeId: json['youtube_id'] as String?,
    );

Map<String, dynamic> _$EmisionModelToJson(EmisionModel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'titulo': instance.titulo,
    'descripcion': instance.descripcion,
    'categoria': instance.categoria,
    'duracion': instance.duracion,
    'fecha': instance.fecha.toIso8601String(),
    'thumbnail': instance.thumbnail,
    'en_vivo': instance.enVivo,
    'vistas': instance.vistas,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('video_url', instance.videoUrl);
  writeNotNull('youtube_id', instance.youtubeId);
  return val;
}
