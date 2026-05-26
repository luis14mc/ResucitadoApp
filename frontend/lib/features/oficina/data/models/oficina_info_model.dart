import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/oficina_info.dart';

part 'oficina_info_model.g.dart';

@JsonSerializable()
class OficinaInfoModel extends OficinaInfo {
  const OficinaInfoModel({
    required super.id,
    required super.direccion,
    required super.telefono,
    required super.email,
    required super.horarios,
    required super.servicios,
    super.latitud,
    super.longitud,
    required super.actualizadoEn,
  });

  factory OficinaInfoModel.fromJson(Map<String, dynamic> json) =>
      _$OficinaInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$OficinaInfoModelToJson(this);

  OficinaInfo toEntity() => this;
}
