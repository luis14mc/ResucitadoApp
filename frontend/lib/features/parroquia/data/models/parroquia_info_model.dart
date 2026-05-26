import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/parroquia_info.dart';

part 'parroquia_info_model.g.dart';

/// Model para serialización JSON de ParroquiaInfo
@JsonSerializable()
class ParroquiaInfoModel extends ParroquiaInfo {
  const ParroquiaInfoModel({
    required super.id,
    required super.nombre,
    required super.historia,
    required super.mision,
    required super.vision,
    required super.valores,
    required super.imagenes,
    required super.direccion,
    required super.telefono,
    required super.email,
    required super.actualizadoEn,
  });

  factory ParroquiaInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ParroquiaInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParroquiaInfoModelToJson(this);

  factory ParroquiaInfoModel.fromEntity(ParroquiaInfo info) {
    return ParroquiaInfoModel(
      id: info.id,
      nombre: info.nombre,
      historia: info.historia,
      mision: info.mision,
      vision: info.vision,
      valores: info.valores,
      imagenes: info.imagenes,
      direccion: info.direccion,
      telefono: info.telefono,
      email: info.email,
      actualizadoEn: info.actualizadoEn,
    );
  }

  ParroquiaInfo toEntity() => this;
}
