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

  factory ParroquiaInfoModel.fromJson(Map<String, dynamic> json) {
    // Parse values/valores safely
    List<String> parseStringList(dynamic list) {
      if (list is List) {
        return list.map((e) => e.toString()).toList();
      }
      return const [];
    }

    // Convert direccion object/map/string to String
    String dirStr = '';
    final dirVal = json['direccion'];
    if (dirVal is Map) {
      final calle = dirVal['calle'] ?? '';
      final colonia = dirVal['colonia'] ?? '';
      final ciudad = dirVal['ciudad'] ?? '';
      final pais = dirVal['pais'] ?? '';
      dirStr = [calle, colonia, ciudad, pais]
          .where((s) => s.toString().isNotEmpty)
          .join(', ');
    } else if (dirVal != null) {
      dirStr = dirVal.toString();
    }

    // Safely parse DateTime (handling ISO8601 variations and -HHMM offsets)
    DateTime parseDateTime(dynamic dateVal) {
      if (dateVal == null) return DateTime.now();
      final str = dateVal.toString();
      final parsed = DateTime.tryParse(str);
      if (parsed != null) return parsed;
      // If it has a timezone offset like -0600 without a colon, add it
      if (str.length >= 5 && (str.endsWith('00') || str.endsWith('30'))) {
        final offsetStart = str.length - 5;
        final sign = str[offsetStart];
        if (sign == '+' || sign == '-') {
          final hours = str.substring(offsetStart + 1, offsetStart + 3);
          final minutes = str.substring(offsetStart + 3);
          final cleanStr =
              str.substring(0, offsetStart) + sign + hours + ':' + minutes;
          final cleanParsed = DateTime.tryParse(cleanStr);
          if (cleanParsed != null) return cleanParsed;
        }
      }
      return DateTime.now();
    }

    return ParroquiaInfoModel(
      id: (json['id'] ?? '').toString(),
      nombre: (json['nombre'] ?? '').toString(),
      historia: (json['historia'] ?? '').toString(),
      mision: (json['mision'] ?? '').toString(),
      vision: (json['vision'] ?? '').toString(),
      valores: parseStringList(json['valores']),
      imagenes: parseStringList(
          json['imagenes'] ?? json['urlImagenes'] ?? json['fotos']),
      direccion: dirStr,
      telefono: (json['telefono'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      actualizadoEn: parseDateTime(json['actualizado_en'] ??
          json['actualizadoEn'] ??
          json['updatedAt'] ??
          json['createdAt']),
    );
  }

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
