// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parroquia_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParroquiaInfoModel _$ParroquiaInfoModelFromJson(Map<String, dynamic> json) =>
    ParroquiaInfoModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      historia: json['historia'] as String,
      mision: json['mision'] as String,
      vision: json['vision'] as String,
      valores:
          (json['valores'] as List<dynamic>).map((e) => e as String).toList(),
      imagenes:
          (json['imagenes'] as List<dynamic>).map((e) => e as String).toList(),
      direccion: json['direccion'] as String,
      telefono: json['telefono'] as String,
      email: json['email'] as String,
      actualizadoEn: DateTime.parse(json['actualizado_en'] as String),
    );

Map<String, dynamic> _$ParroquiaInfoModelToJson(ParroquiaInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'historia': instance.historia,
      'mision': instance.mision,
      'vision': instance.vision,
      'valores': instance.valores,
      'imagenes': instance.imagenes,
      'direccion': instance.direccion,
      'telefono': instance.telefono,
      'email': instance.email,
      'actualizado_en': instance.actualizadoEn.toIso8601String(),
    };
