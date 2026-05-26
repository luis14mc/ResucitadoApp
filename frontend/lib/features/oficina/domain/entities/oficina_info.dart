import 'package:equatable/equatable.dart';

/// Entity para información de la oficina parroquial
class OficinaInfo extends Equatable {
  final String id;
  final String direccion;
  final String telefono;
  final String email;
  final Map<String, String> horarios; // día => horario
  final List<String> servicios;
  final double? latitud;
  final double? longitud;
  final DateTime actualizadoEn;

  const OficinaInfo({
    required this.id,
    required this.direccion,
    required this.telefono,
    required this.email,
    required this.horarios,
    required this.servicios,
    this.latitud,
    this.longitud,
    required this.actualizadoEn,
  });

  @override
  List<Object?> get props => [
        id,
        direccion,
        telefono,
        email,
        horarios,
        servicios,
        latitud,
        longitud,
        actualizadoEn,
      ];
}
