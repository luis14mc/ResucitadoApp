// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'horario_misa_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HorarioMisaModel _$HorarioMisaModelFromJson(Map<String, dynamic> json) =>
    HorarioMisaModel(
      id: json['id'] as String,
      tipo: $enumDecode(_$TipoMisaEnumMap, json['tipo']),
      dia: $enumDecodeNullable(_$DiaSemanaEnumMap, json['dia']),
      hora: json['hora'] as String,
      lugar: json['lugar'] as String,
      sacerdote: json['sacerdote'] as String?,
      descripcion: json['descripcion'] as String?,
      activo: json['activo'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$HorarioMisaModelToJson(HorarioMisaModel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'tipo': _$TipoMisaEnumMap[instance.tipo]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('dia', _$DiaSemanaEnumMap[instance.dia]);
  val['hora'] = instance.hora;
  val['lugar'] = instance.lugar;
  writeNotNull('sacerdote', instance.sacerdote);
  writeNotNull('descripcion', instance.descripcion);
  val['activo'] = instance.activo;
  val['created_at'] = instance.createdAt.toIso8601String();
  val['updated_at'] = instance.updatedAt.toIso8601String();
  return val;
}

const _$TipoMisaEnumMap = {
  TipoMisa.diaria: 'diaria',
  TipoMisa.dominical: 'dominical',
  TipoMisa.festivo: 'festivo',
  TipoMisa.especial: 'especial',
};

const _$DiaSemanaEnumMap = {
  DiaSemana.lunes: 'lunes',
  DiaSemana.martes: 'martes',
  DiaSemana.miercoles: 'miercoles',
  DiaSemana.jueves: 'jueves',
  DiaSemana.viernes: 'viernes',
  DiaSemana.sabado: 'sabado',
  DiaSemana.domingo: 'domingo',
};
