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

  factory HorarioMisaModel.fromJson(Map<String, dynamic> json) =>
      _$HorarioMisaModelFromJson(json);

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
