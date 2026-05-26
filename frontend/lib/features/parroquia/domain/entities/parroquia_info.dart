import 'package:equatable/equatable.dart';

/// Entity para información de la parroquia
class ParroquiaInfo extends Equatable {
  final String id;
  final String nombre;
  final String historia;
  final String mision;
  final String vision;
  final List<String> valores;
  final List<String> imagenes;
  final String direccion;
  final String telefono;
  final String email;
  final DateTime actualizadoEn;

  const ParroquiaInfo({
    required this.id,
    required this.nombre,
    required this.historia,
    required this.mision,
    required this.vision,
    required this.valores,
    required this.imagenes,
    required this.direccion,
    required this.telefono,
    required this.email,
    required this.actualizadoEn,
  });

  @override
  List<Object?> get props => [
        id,
        nombre,
        historia,
        mision,
        vision,
        valores,
        imagenes,
        direccion,
        telefono,
        email,
        actualizadoEn,
      ];
}
