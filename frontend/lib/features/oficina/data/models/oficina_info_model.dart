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

  factory OficinaInfoModel.fromJson(Map<String, dynamic> json) {
    // 1. Resolve direccion from 'ubicacion' or 'direccion'
    final String dirStr = json['ubicacion']?.toString() ?? json['direccion']?.toString() ?? 'Oficina Parroquial';

    // 2. Resolve telefono and email from 'contacto' or root
    String telStr = '';
    String emailStr = '';
    final contactoVal = json['contacto'];
    if (contactoVal is Map) {
      telStr = contactoVal['telefono']?.toString() ?? '';
      emailStr = contactoVal['email']?.toString() ?? '';
    } else {
      telStr = json['telefono']?.toString() ?? '';
      emailStr = json['email']?.toString() ?? '';
    }

    // 3. Resolve horarios (Map<String, String>) from 'horarioAtencion' list or 'horarios' map
    final Map<String, String> parsedHorarios = {};
    final horarioAtencionVal = json['horarioAtencion'] ?? json['horarios'];
    if (horarioAtencionVal is List) {
      for (final item in horarioAtencionVal) {
        if (item is Map) {
          final dia = (item['dia'] ?? '').toString();
          final ap = (item['horaApertura'] ?? item['apertura'] ?? '').toString();
          final cier = (item['horaCierre'] ?? item['cierre'] ?? '').toString();
          if (dia.isNotEmpty) {
            parsedHorarios[dia] = '$ap - $cier';
          }
        }
      }
    } else if (horarioAtencionVal is Map) {
      horarioAtencionVal.forEach((key, value) {
        parsedHorarios[key.toString()] = value.toString();
      });
    }

    if (parsedHorarios.isEmpty) {
      parsedHorarios['Lunes a Viernes'] = '08:00 AM - 12:00 PM, 02:00 PM - 05:00 PM';
      parsedHorarios['Sábados'] = '08:00 AM - 12:00 PM';
    }

    // 4. Resolve servicios (List<String>) from 'servicios' list of objects or list of strings
    final List<String> parsedServicios = [];
    final serviciosVal = json['servicios'];
    if (serviciosVal is List) {
      for (final item in serviciosVal) {
        if (item is Map) {
          final nombre = item['nombre']?.toString() ?? '';
          if (nombre.isNotEmpty) {
            parsedServicios.add(nombre);
          }
        } else if (item != null) {
          parsedServicios.add(item.toString());
        }
      }
    }

    if (parsedServicios.isEmpty) {
      parsedServicios.addAll(['Bautismos', 'Matrimonios', 'Confesiones', 'Intenciones de Misa']);
    }

    // 5. Parse coordinates
    double? lat;
    double? lng;
    final coordVal = json['coordenadas'];
    if (coordVal is Map) {
      lat = double.tryParse(coordVal['latitud']?.toString() ?? coordVal['lat']?.toString() ?? '');
      lng = double.tryParse(coordVal['longitud']?.toString() ?? coordVal['lng']?.toString() ?? '');
    } else {
      lat = double.tryParse(json['latitud']?.toString() ?? json['lat']?.toString() ?? '');
      lng = double.tryParse(json['longitud']?.toString() ?? json['lng']?.toString() ?? '');
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
          final cleanStr = str.substring(0, offsetStart) + sign + hours + ':' + minutes;
          final cleanParsed = DateTime.tryParse(cleanStr);
          if (cleanParsed != null) return cleanParsed;
        }
      }
      return DateTime.now();
    }

    return OficinaInfoModel(
      id: (json['id'] ?? '').toString(),
      direccion: dirStr,
      telefono: telStr.isNotEmpty ? telStr : '+504 2226-1111',
      email: emailStr.isNotEmpty ? emailStr : 'oficina@cristoresucitado.hn',
      horarios: parsedHorarios,
      servicios: parsedServicios,
      latitud: lat ?? 14.0435,
      longitud: lng ?? -87.2186,
      actualizadoEn: parseDateTime(json['actualizado_en'] ?? json['actualizadoEn'] ?? json['updatedAt'] ?? json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => _$OficinaInfoModelToJson(this);

  OficinaInfo toEntity() => this;
}
