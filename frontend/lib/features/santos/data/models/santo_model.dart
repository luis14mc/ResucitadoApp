import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/santo.dart';

part 'santo_model.g.dart';

@JsonSerializable()
class SantoModel extends Santo {
  const SantoModel({
    required super.id,
    required super.nombre,
    required super.titulo,
    required super.fechaCelebracion,
    required super.biografia,
    required super.festividad,
    required super.patrono,
    required super.oracion,
    super.imagenUrl,
    required super.atributos,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SantoModel.fromJson(Map<String, dynamic> json) =>
      _$SantoModelFromJson(json);

  Map<String, dynamic> toJson() => _$SantoModelToJson(this);

  factory SantoModel.fromEntity(Santo santo) {
    return SantoModel(
      id: santo.id,
      nombre: santo.nombre,
      titulo: santo.titulo,
      fechaCelebracion: santo.fechaCelebracion,
      biografia: santo.biografia,
      festividad: santo.festividad,
      patrono: santo.patrono,
      oracion: santo.oracion,
      imagenUrl: santo.imagenUrl,
      atributos: santo.atributos,
      createdAt: santo.createdAt,
      updatedAt: santo.updatedAt,
    );
  }

  Santo toEntity() {
    return Santo(
      id: id,
      nombre: nombre,
      titulo: titulo,
      fechaCelebracion: fechaCelebracion,
      biografia: biografia,
      festividad: festividad,
      patrono: patrono,
      oracion: oracion,
      imagenUrl: imagenUrl,
      atributos: atributos,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
