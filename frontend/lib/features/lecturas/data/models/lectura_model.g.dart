// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lectura_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LecturaModel _$LecturaModelFromJson(Map<String, dynamic> json) => LecturaModel(
      id: json['id'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
      tiempoLiturgico: json['tiempo_liturgico'] as String,
      colorLiturgico: json['color_liturgico'] as String,
      primeraLectura: LecturaModel._primeraLecturaFromJson(
          json['primera_lectura'] as Map<String, dynamic>),
      salmo: LecturaModel._salmoFromJson(json['salmo'] as Map<String, dynamic>),
      segundaLectura: LecturaModel._segundaLecturaFromJson(
          json['segunda_lectura'] as Map<String, dynamic>?),
      evangelio: LecturaModel._evangelioFromJson(
          json['evangelio'] as Map<String, dynamic>),
      reflexion: LecturaModel._reflexionFromJson(
          json['reflexion'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$LecturaModelToJson(LecturaModel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'fecha': instance.fecha.toIso8601String(),
    'tiempo_liturgico': instance.tiempoLiturgico,
    'color_liturgico': instance.colorLiturgico,
    'primera_lectura':
        LecturaModel._primeraLecturaToJson(instance.primeraLectura),
    'salmo': LecturaModel._salmoToJson(instance.salmo),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('segunda_lectura',
      LecturaModel._segundaLecturaToJson(instance.segundaLectura));
  val['evangelio'] = LecturaModel._evangelioToJson(instance.evangelio);
  writeNotNull('reflexion', LecturaModel._reflexionToJson(instance.reflexion));
  return val;
}

PrimeraLecturaModel _$PrimeraLecturaModelFromJson(Map<String, dynamic> json) =>
    PrimeraLecturaModel(
      titulo: json['titulo'] as String,
      referencia: json['referencia'] as String,
      texto: json['texto'] as String,
    );

Map<String, dynamic> _$PrimeraLecturaModelToJson(
        PrimeraLecturaModel instance) =>
    <String, dynamic>{
      'titulo': instance.titulo,
      'referencia': instance.referencia,
      'texto': instance.texto,
    };

SalmoModel _$SalmoModelFromJson(Map<String, dynamic> json) => SalmoModel(
      titulo: json['titulo'] as String,
      referencia: json['referencia'] as String,
      texto: json['texto'] as String,
      respuesta: json['respuesta'] as String,
    );

Map<String, dynamic> _$SalmoModelToJson(SalmoModel instance) =>
    <String, dynamic>{
      'titulo': instance.titulo,
      'referencia': instance.referencia,
      'texto': instance.texto,
      'respuesta': instance.respuesta,
    };

SegundaLecturaModel _$SegundaLecturaModelFromJson(Map<String, dynamic> json) =>
    SegundaLecturaModel(
      titulo: json['titulo'] as String,
      referencia: json['referencia'] as String,
      texto: json['texto'] as String,
    );

Map<String, dynamic> _$SegundaLecturaModelToJson(
        SegundaLecturaModel instance) =>
    <String, dynamic>{
      'titulo': instance.titulo,
      'referencia': instance.referencia,
      'texto': instance.texto,
    };

EvangelioModel _$EvangelioModelFromJson(Map<String, dynamic> json) =>
    EvangelioModel(
      titulo: json['titulo'] as String,
      referencia: json['referencia'] as String,
      texto: json['texto'] as String,
    );

Map<String, dynamic> _$EvangelioModelToJson(EvangelioModel instance) =>
    <String, dynamic>{
      'titulo': instance.titulo,
      'referencia': instance.referencia,
      'texto': instance.texto,
    };

ReflexionModel _$ReflexionModelFromJson(Map<String, dynamic> json) =>
    ReflexionModel(
      titulo: json['titulo'] as String,
      fuente: json['fuente'] as String,
      texto: json['texto'] as String,
    );

Map<String, dynamic> _$ReflexionModelToJson(ReflexionModel instance) =>
    <String, dynamic>{
      'titulo': instance.titulo,
      'fuente': instance.fuente,
      'texto': instance.texto,
    };
