import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/horario_misa.dart';

part 'horario_misa_model.g.dart';

@JsonSerializable()
class HorarioMisaModel extends HorarioMisa {
  const HorarioMisaModel({
    required super.id,
    required super.tipo,
    super.dia,
    required super.hora,
    required super.lugar,
    super.sacerdote,
    super.descripcion,
    super.activo,
    required super.createdAt,
    required super.updatedAt,
  });

  factory HorarioMisaModel.fromJson(Map<String, dynamic> json) {
    // Parse tipo enum
    final tipoStr = (json['tipo'] ?? '').toString().toLowerCase();
    TipoMisa tipoEnum = TipoMisa.especial;
    if (tipoStr.contains('diaria')) {
      tipoEnum = TipoMisa.diaria;
    } else if (tipoStr.contains('dominical')) {
      tipoEnum = TipoMisa.dominical;
    } else if (tipoStr.contains('festivo')) {
      tipoEnum = TipoMisa.festivo;
    } else {
      tipoEnum = TipoMisa.values.firstWhere(
        (e) => e.name.toLowerCase() == tipoStr,
        orElse: () => TipoMisa.especial,
      );
    }

    // Parse dia enum
    final diaStr = (json['dia'] ?? '').toString().toLowerCase();
    DiaSemana? diaEnum;
    if (diaStr.isNotEmpty) {
      if (diaStr.contains('lun')) diaEnum = DiaSemana.lunes;
      else if (diaStr.contains('mar')) diaEnum = DiaSemana.martes;
      else if (diaStr.contains('mie') || diaStr.contains('mié')) diaEnum = DiaSemana.miercoles;
      else if (diaStr.contains('jue')) diaEnum = DiaSemana.jueves;
      else if (diaStr.contains('vie')) diaEnum = DiaSemana.viernes;
      else if (diaStr.contains('sab') || diaStr.contains('sáb')) diaEnum = DiaSemana.sabado;
      else if (diaStr.contains('dom')) diaEnum = DiaSemana.domingo;
      else {
        diaEnum = DiaSemana.values.firstWhere(
          (e) => e.name.toLowerCase() == diaStr || e.displayName.toLowerCase() == diaStr,
          orElse: () => DiaSemana.lunes,
        );
      }
    }

    return HorarioMisaModel(
      id: (json['id'] ?? '').toString(),
      tipo: tipoEnum,
      dia: diaEnum,
      hora: (json['hora'] ?? '').toString(),
      lugar: (json['lugar'] ?? '').toString(),
      sacerdote: json['sacerdote']?.toString() ?? json['celebrante']?.toString(),
      descripcion: json['descripcion']?.toString() ?? json['notas']?.toString(),
      activo: json['activo'] is bool ? json['activo'] as bool : true,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now() : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now() : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => _$HorarioMisaModelToJson(this);

  factory HorarioMisaModel.fromEntity(HorarioMisa horario) {
    return HorarioMisaModel(
      id: horario.id,
      tipo: horario.tipo,
      dia: horario.dia,
      hora: horario.hora,
      lugar: horario.lugar,
      sacerdote: horario.sacerdote,
      descripcion: horario.descripcion,
      activo: horario.activo,
      createdAt: horario.createdAt,
      updatedAt: horario.updatedAt,
    );
  }

  HorarioMisa toEntity() {
    return HorarioMisa(
      id: id,
      tipo: tipo,
      dia: dia,
      hora: hora,
      lugar: lugar,
      sacerdote: sacerdote,
      descripcion: descripcion,
      activo: activo,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
