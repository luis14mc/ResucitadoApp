import 'package:equatable/equatable.dart';

enum EventoCategoria { liturgia, comunidad, juventud, formacion, mision }

class Evento extends Equatable {
  final String id;
  final String titulo;
  final String descripcion;
  final DateTime fecha;
  final String hora;
  final String lugar;
  final EventoCategoria categoria;
  final String? imagenUrl;
  final bool esRecurrente;
  final String? frecuenciaRecurrencia;
  final int? maximoParticipantes;
  final int participantesActuales;
  final bool requiereInscripcion;
  final String? contactoResponsable;
  final String? telefono;
  final String? email;
  final List<String> etiquetas;
  final bool activo;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Evento({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.hora,
    required this.lugar,
    required this.categoria,
    this.imagenUrl,
    this.esRecurrente = false,
    this.frecuenciaRecurrencia,
    this.maximoParticipantes,
    this.participantesActuales = 0,
    this.requiereInscripcion = false,
    this.contactoResponsable,
    this.telefono,
    this.email,
    this.etiquetas = const [],
    this.activo = true,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        titulo,
        descripcion,
        fecha,
        hora,
        lugar,
        categoria,
        imagenUrl,
        esRecurrente,
        frecuenciaRecurrencia,
        maximoParticipantes,
        participantesActuales,
        requiereInscripcion,
        contactoResponsable,
        telefono,
        email,
        etiquetas,
        activo,
        createdAt,
        updatedAt,
      ];

  bool get hayEspaciosDisponibles {
    if (maximoParticipantes == null) return true;
    return participantesActuales < maximoParticipantes!;
  }

  bool get estaVencido {
    return DateTime.now().isAfter(fecha);
  }

  String get categoriaTexto {
    switch (categoria) {
      case EventoCategoria.liturgia:
        return 'Liturgia';
      case EventoCategoria.comunidad:
        return 'Comunidad';
      case EventoCategoria.juventud:
        return 'Juventud';
      case EventoCategoria.formacion:
        return 'Formación';
      case EventoCategoria.mision:
        return 'Misión';
    }
  }

  Evento copyWith({
    String? id,
    String? titulo,
    String? descripcion,
    DateTime? fecha,
    String? hora,
    String? lugar,
    EventoCategoria? categoria,
    String? imagenUrl,
    bool? esRecurrente,
    String? frecuenciaRecurrencia,
    int? maximoParticipantes,
    int? participantesActuales,
    bool? requiereInscripcion,
    String? contactoResponsable,
    String? telefono,
    String? email,
    List<String>? etiquetas,
    bool? activo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Evento(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      fecha: fecha ?? this.fecha,
      hora: hora ?? this.hora,
      lugar: lugar ?? this.lugar,
      categoria: categoria ?? this.categoria,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      esRecurrente: esRecurrente ?? this.esRecurrente,
      frecuenciaRecurrencia:
          frecuenciaRecurrencia ?? this.frecuenciaRecurrencia,
      maximoParticipantes: maximoParticipantes ?? this.maximoParticipantes,
      participantesActuales:
          participantesActuales ?? this.participantesActuales,
      requiereInscripcion: requiereInscripcion ?? this.requiereInscripcion,
      contactoResponsable: contactoResponsable ?? this.contactoResponsable,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      etiquetas: etiquetas ?? this.etiquetas,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
