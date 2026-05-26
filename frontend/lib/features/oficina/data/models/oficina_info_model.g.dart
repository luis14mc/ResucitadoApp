// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oficina_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OficinaInfoModel _$OficinaInfoModelFromJson(Map<String, dynamic> json) =>
    OficinaInfoModel(
      id: json['id'] as String,
      direccion: json['direccion'] as String,
      telefono: json['telefono'] as String,
      email: json['email'] as String,
      horarios: Map<String, String>.from(json['horarios'] as Map),
      servicios:
          (json['servicios'] as List<dynamic>).map((e) => e as String).toList(),
      latitud: (json['latitud'] as num?)?.toDouble(),
      longitud: (json['longitud'] as num?)?.toDouble(),
      actualizadoEn: DateTime.parse(json['actualizado_en'] as String),
    );

Map<String, dynamic> _$OficinaInfoModelToJson(OficinaInfoModel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'direccion': instance.direccion,
    'telefono': instance.telefono,
    'email': instance.email,
    'horarios': instance.horarios,
    'servicios': instance.servicios,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('latitud', instance.latitud);
  writeNotNull('longitud', instance.longitud);
  val['actualizado_en'] = instance.actualizadoEn.toIso8601String();
  return val;
}
