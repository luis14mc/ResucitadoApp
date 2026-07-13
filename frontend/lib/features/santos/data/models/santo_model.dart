import 'dart:convert';
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

  factory SantoModel.fromJson(Map<String, dynamic> json) {
    // 1. Resolve patrono to a String (join lists if needed)
    String patronoStr = '';
    final patVal = json['patrono'];
    if (patVal is List) {
      patronoStr = patVal.join(', ');
    } else if (patVal != null) {
      patronoStr = patVal.toString();
    }

    // 2. Parse fechaCelebracion (handling MM-DD or DateTime)
    final String fcStr = (json['fechaCelebracion'] ?? '').toString();
    DateTime parsedDate = DateTime.now();
    if (fcStr.isNotEmpty) {
      if (fcStr.length == 5 && fcStr.contains('-')) {
        final parts = fcStr.split('-');
        final mesVal = int.tryParse(parts[0]) ?? 1;
        final diaVal = int.tryParse(parts[1]) ?? 1;
        parsedDate = DateTime(DateTime.now().year, mesVal, diaVal);
      } else {
        parsedDate = DateTime.tryParse(fcStr) ?? DateTime.now();
      }
    }

    // 3. Parse atributos (List<String>)
    List<String> parsedAtributos = [];
    final atrVal = json['atributos'];
    if (atrVal is List) {
      parsedAtributos = atrVal.map((e) => e.toString()).toList();
    } else if (atrVal is String) {
      try {
        final decoded = jsonDecode(atrVal);
        if (decoded is List) {
          parsedAtributos = decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {}
    }

    return SantoModel(
      id: (json['id'] ?? '').toString(),
      nombre: (json['nombre'] ?? '').toString(),
      titulo: json['titulo']?.toString() ?? '',
      fechaCelebracion: parsedDate,
      biografia: (json['biografia'] ?? '').toString(),
      festividad: (json['festividad'] ?? '').toString(),
      patrono: patronoStr,
      oracion: (json['oracion'] ?? '').toString(),
      imagenUrl: json['imagenUrl']?.toString() ?? json['imagen_url']?.toString(),
      atributos: parsedAtributos,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now() : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now() : DateTime.now(),
    );
  }

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
