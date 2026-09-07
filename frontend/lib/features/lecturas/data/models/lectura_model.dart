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

  factory LecturaModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> parseSubJson(dynamic val) {
      if (val is Map<String, dynamic>) return val;
      if (val is Map) return Map<String, dynamic>.from(val);
      return const <String, dynamic>{};
    }

    return LecturaModel(
      id: (json['id'] ?? '').toString(),
      fecha: json['fecha'] != null
          ? DateTime.tryParse(json['fecha'].toString()) ?? DateTime.now()
          : DateTime.now(),
      tiempoLiturgico:
          (json['tiempoLiturgico'] ?? json['tiempo_liturgico'] ?? '')
              .toString(),
      colorLiturgico:
          (json['colorLiturgico'] ?? json['color_liturgico'] ?? '').toString(),
      primeraLectura: PrimeraLecturaModel.fromJson(
          parseSubJson(json['primeraLectura'] ?? json['primera_lectura'])),
      salmo: SalmoModel.fromJson(parseSubJson(json['salmo'])),
      segundaLectura: (json['segundaLectura'] ?? json['segunda_lectura']) !=
              null
          ? SegundaLecturaModel.fromJson(
              parseSubJson(json['segundaLectura'] ?? json['segunda_lectura']))
          : null,
      evangelio: EvangelioModel.fromJson(parseSubJson(json['evangelio'])),
      reflexion: () {
        final raw = json['reflexion'] ?? json['reflexion_texto'];
        if (raw is String && raw.trim().isNotEmpty) {
          return ReflexionModel.fromJson({
            'titulo': 'Reflexión',
            'fuente': json['fuente'] ?? '',
            'texto': raw,
          });
        }
        if (raw is Map) {
          return ReflexionModel.fromJson(parseSubJson(raw));
        }
        return null;
      }(),
    );
  }

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

  factory PrimeraLecturaModel.fromJson(Map<String, dynamic> json) {
    return PrimeraLecturaModel(
      titulo: (json['titulo'] ?? '').toString(),
      referencia: (json['referencia'] ?? json['cita'] ?? '').toString(),
      texto: (json['texto'] ?? '').toString(),
    );
  }

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

  factory SalmoModel.fromJson(Map<String, dynamic> json) {
    return SalmoModel(
      titulo: (json['titulo'] ?? '').toString(),
      referencia: (json['referencia'] ?? json['cita'] ?? '').toString(),
      texto: (json['texto'] ?? '').toString(),
      respuesta: (json['respuesta'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => _$SalmoModelToJson(this);
}

@JsonSerializable()
class SegundaLecturaModel extends SegundaLectura {
  const SegundaLecturaModel({
    required super.titulo,
    required super.referencia,
    required super.texto,
  });

  factory SegundaLecturaModel.fromJson(Map<String, dynamic> json) {
    return SegundaLecturaModel(
      titulo: (json['titulo'] ?? '').toString(),
      referencia: (json['referencia'] ?? json['cita'] ?? '').toString(),
      texto: (json['texto'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => _$SegundaLecturaModelToJson(this);
}

@JsonSerializable()
class EvangelioModel extends Evangelio {
  const EvangelioModel({
    required super.titulo,
    required super.referencia,
    required super.texto,
  });

  factory EvangelioModel.fromJson(Map<String, dynamic> json) {
    return EvangelioModel(
      titulo: (json['titulo'] ?? '').toString(),
      referencia: (json['referencia'] ?? json['cita'] ?? '').toString(),
      texto: (json['texto'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => _$EvangelioModelToJson(this);
}

@JsonSerializable()
class ReflexionModel extends Reflexion {
  const ReflexionModel({
    required super.titulo,
    required super.fuente,
    required super.texto,
  });

  factory ReflexionModel.fromJson(Map<String, dynamic> json) {
    return ReflexionModel(
      titulo: (json['titulo'] ?? '').toString(),
      fuente: (json['fuente'] ?? json['autor'] ?? '').toString(),
      texto: (json['texto'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => _$ReflexionModelToJson(this);
}
