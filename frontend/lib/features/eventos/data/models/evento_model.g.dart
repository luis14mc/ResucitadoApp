// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evento_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventoModel _$EventoModelFromJson(Map<String, dynamic> json) => EventoModel(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
      hora: json['hora'] as String,
      lugar: json['lugar'] as String,
      categoria: $enumDecode(_$EventoCategoriaEnumMap, json['categoria']),
      imagenUrl: json['imagen_url'] as String?,
      esRecurrente: json['es_recurrente'] as bool? ?? false,
      frecuenciaRecurrencia: json['frecuencia_recurrencia'] as String?,
      maximoParticipantes: (json['maximo_participantes'] as num?)?.toInt(),
      participantesActuales:
          (json['participantes_actuales'] as num?)?.toInt() ?? 0,
      requiereInscripcion: json['requiere_inscripcion'] as bool? ?? false,
      contactoResponsable: json['contacto_responsable'] as String?,
      telefono: json['telefono'] as String?,
      email: json['email'] as String?,
      etiquetas: (json['etiquetas'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      activo: json['activo'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$EventoModelToJson(EventoModel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'titulo': instance.titulo,
    'descripcion': instance.descripcion,
    'fecha': instance.fecha.toIso8601String(),
    'hora': instance.hora,
    'lugar': instance.lugar,
    'categoria': _$EventoCategoriaEnumMap[instance.categoria]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('imagen_url', instance.imagenUrl);
  val['es_recurrente'] = instance.esRecurrente;
  writeNotNull('frecuencia_recurrencia', instance.frecuenciaRecurrencia);
  writeNotNull('maximo_participantes', instance.maximoParticipantes);
  val['participantes_actuales'] = instance.participantesActuales;
  val['requiere_inscripcion'] = instance.requiereInscripcion;
  writeNotNull('contacto_responsable', instance.contactoResponsable);
  writeNotNull('telefono', instance.telefono);
  writeNotNull('email', instance.email);
  val['etiquetas'] = instance.etiquetas;
  val['activo'] = instance.activo;
  val['created_at'] = instance.createdAt.toIso8601String();
  val['updated_at'] = instance.updatedAt.toIso8601String();
  return val;
}

const _$EventoCategoriaEnumMap = {
  EventoCategoria.liturgia: 'liturgia',
  EventoCategoria.comunidad: 'comunidad',
  EventoCategoria.juventud: 'juventud',
  EventoCategoria.formacion: 'formacion',
  EventoCategoria.mision: 'mision',
};
