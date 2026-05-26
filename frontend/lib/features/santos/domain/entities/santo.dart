import 'package:equatable/equatable.dart';

class Santo extends Equatable {
  final String id;
  final String nombre;
  final String titulo;
  final DateTime fechaCelebracion;
  final String biografia;
  final String festividad;
  final String patrono;
  final String oracion;
  final String? imagenUrl;
  final List<String> atributos;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Santo({
    required this.id,
    required this.nombre,
    required this.titulo,
    required this.fechaCelebracion,
    required this.biografia,
    required this.festividad,
    required this.patrono,
    required this.oracion,
    this.imagenUrl,
    required this.atributos,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        nombre,
        titulo,
        fechaCelebracion,
        biografia,
        festividad,
        patrono,
        oracion,
        imagenUrl,
        atributos,
        createdAt,
        updatedAt,
      ];

  Santo copyWith({
    String? id,
    String? nombre,
    String? titulo,
    DateTime? fechaCelebracion,
    String? biografia,
    String? festividad,
    String? patrono,
    String? oracion,
    String? imagenUrl,
    List<String>? atributos,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Santo(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      titulo: titulo ?? this.titulo,
      fechaCelebracion: fechaCelebracion ?? this.fechaCelebracion,
      biografia: biografia ?? this.biografia,
      festividad: festividad ?? this.festividad,
      patrono: patrono ?? this.patrono,
      oracion: oracion ?? this.oracion,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      atributos: atributos ?? this.atributos,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
