import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/lectura.dart';

part 'lectura_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LecturaModel extends Lectura {
  @override
  @JsonKey(fromJson: _primeraLecturaFromJson, toJson: _primeraLecturaToJson)
  final PrimeraLecturaModel primeraLectura;

  @override
  @JsonKey(fromJson: _salmoFromJson, toJson: _salmoToJson)
  final SalmoModel salmo;

  @override
  @JsonKey(fromJson: _segundaLecturaFromJson, toJson: _segundaLecturaToJson)
  final SegundaLecturaModel? segundaLectura;

  @override
  @JsonKey(fromJson: _evangelioFromJson, toJson: _evangelioToJson)
  final EvangelioModel evangelio;

  @override
  @JsonKey(fromJson: _reflexionFromJson, toJson: _reflexionToJson)
  final ReflexionModel? reflexion;

  const LecturaModel({
    required super.id,
    required super.fecha,
    required super.tiempoLiturgico,
    required super.colorLiturgico,
    required this.primeraLectura,
    required this.salmo,
    this.segundaLectura,
    required this.evangelio,
    this.reflexion,
  }) : super(
          primeraLectura: primeraLectura,
          salmo: salmo,
          segundaLectura: segundaLectura,
          evangelio: evangelio,
          reflexion: reflexion,
        );

  factory LecturaModel.fromJson(Map<String, dynamic> json) =>
      _$LecturaModelFromJson(json);

  Map<String, dynamic> toJson() => _$LecturaModelToJson(this);

  static PrimeraLecturaModel _primeraLecturaFromJson(
          Map<String, dynamic> json) =>
      PrimeraLecturaModel.fromJson(json);

  static Map<String, dynamic> _primeraLecturaToJson(PrimeraLectura lectura) =>
      (lectura as PrimeraLecturaModel).toJson();

  static SalmoModel _salmoFromJson(Map<String, dynamic> json) =>
      SalmoModel.fromJson(json);

  static Map<String, dynamic> _salmoToJson(Salmo salmo) =>
      (salmo as SalmoModel).toJson();

  static SegundaLecturaModel? _segundaLecturaFromJson(
          Map<String, dynamic>? json) =>
      json != null ? SegundaLecturaModel.fromJson(json) : null;

  static Map<String, dynamic>? _segundaLecturaToJson(SegundaLectura? lectura) =>
      lectura != null ? (lectura as SegundaLecturaModel).toJson() : null;

  static EvangelioModel _evangelioFromJson(Map<String, dynamic> json) =>
      EvangelioModel.fromJson(json);

  static Map<String, dynamic> _evangelioToJson(Evangelio evangelio) =>
      (evangelio as EvangelioModel).toJson();

  static ReflexionModel? _reflexionFromJson(Map<String, dynamic>? json) =>
      json != null ? ReflexionModel.fromJson(json) : null;

  static Map<String, dynamic>? _reflexionToJson(Reflexion? reflexion) =>
      reflexion != null ? (reflexion as ReflexionModel).toJson() : null;
}

@JsonSerializable()
class PrimeraLecturaModel extends PrimeraLectura {
  const PrimeraLecturaModel({
    required super.titulo,
    required super.referencia,
    required super.texto,
  });

  factory PrimeraLecturaModel.fromJson(Map<String, dynamic> json) =>
      _$PrimeraLecturaModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrimeraLecturaModelToJson(this);
}

@JsonSerializable()
class SalmoModel extends Salmo {
  const SalmoModel({
    required super.titulo,
    required super.referencia,
    required super.texto,
    required super.respuesta,
  });

  factory SalmoModel.fromJson(Map<String, dynamic> json) =>
      _$SalmoModelFromJson(json);

  Map<String, dynamic> toJson() => _$SalmoModelToJson(this);
}

@JsonSerializable()
class SegundaLecturaModel extends SegundaLectura {
  const SegundaLecturaModel({
    required super.titulo,
    required super.referencia,
    required super.texto,
  });

  factory SegundaLecturaModel.fromJson(Map<String, dynamic> json) =>
      _$SegundaLecturaModelFromJson(json);

  Map<String, dynamic> toJson() => _$SegundaLecturaModelToJson(this);
}

@JsonSerializable()
class EvangelioModel extends Evangelio {
  const EvangelioModel({
    required super.titulo,
    required super.referencia,
    required super.texto,
  });

  factory EvangelioModel.fromJson(Map<String, dynamic> json) =>
      _$EvangelioModelFromJson(json);

  Map<String, dynamic> toJson() => _$EvangelioModelToJson(this);
}

@JsonSerializable()
class ReflexionModel extends Reflexion {
  const ReflexionModel({
    required super.titulo,
    required super.fuente,
    required super.texto,
  });

  factory ReflexionModel.fromJson(Map<String, dynamic> json) =>
      _$ReflexionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReflexionModelToJson(this);
}
