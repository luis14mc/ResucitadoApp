import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/evento.dart';

part 'evento_model.g.dart';

@JsonSerializable()
class EventoModel extends Evento {
  const EventoModel({
    required super.id,
    required super.titulo,
    required super.descripcion,
    required super.fecha,
    required super.hora,
    required super.lugar,
    required super.categoria,
    super.imagenUrl,
    super.esRecurrente,
    super.frecuenciaRecurrencia,
    super.maximoParticipantes,
    super.participantesActuales,
    super.requiereInscripcion,
    super.contactoResponsable,
    super.telefono,
    super.email,
    super.etiquetas,
    super.activo,
    required super.createdAt,
    required super.updatedAt,
  });

  factory EventoModel.fromJson(Map<String, dynamic> json) {
    // Map backend categories to frontend EventoCategoria
    final catStr = (json['categoria'] ?? '').toString().toLowerCase();
    EventoCategoria catEnum;
    if (catStr.contains('misa') || catStr.contains('litur')) {
      catEnum = EventoCategoria.liturgia;
    } else if (catStr.contains('social') || catStr.contains('comun')) {
      catEnum = EventoCategoria.comunidad;
    } else if (catStr.contains('juven') || catStr.contains('juve')) {
      catEnum = EventoCategoria.juventud;
    } else if (catStr.contains('form') || catStr.contains('cateq') || catStr.contains('retir')) {
      catEnum = EventoCategoria.formacion;
    } else {
      catEnum = EventoCategoria.values.firstWhere(
        (e) => e.name.toLowerCase() == catStr,
        orElse: () => EventoCategoria.mision,
      );
    }

    // Parse etiquetas
    List<String> tags = [];
    if (json['etiquetas'] is List) {
      tags = (json['etiquetas'] as List).map((e) => e.toString()).toList();
    } else if (json['etiquetas'] is String) {
      try {
        final parsed = jsonDecode(json['etiquetas']);
        if (parsed is List) {
          tags = parsed.map((e) => e.toString()).toList();
        }
      } catch (_) {}
    }

    return EventoModel(
      id: (json['id'] ?? '').toString(),
      titulo: (json['titulo'] ?? '').toString(),
      descripcion: (json['descripcion'] ?? '').toString(),
      fecha: json['fecha'] != null ? DateTime.tryParse(json['fecha'].toString()) ?? DateTime.now() : DateTime.now(),
      hora: (json['hora'] ?? '').toString(),
      lugar: (json['lugar'] ?? '').toString(),
      categoria: catEnum,
      imagenUrl: json['imagenUrl']?.toString() ?? json['imagen_url']?.toString(),
      esRecurrente: json['esRecurrente'] is bool ? json['esRecurrente'] as bool : false,
      frecuenciaRecurrencia: json['frecuenciaRecurrencia']?.toString() ?? json['frecuencia_recurrencia']?.toString(),
      maximoParticipantes: json['maximoParticipantes'] is int ? json['maximoParticipantes'] as int : null,
      participantesActuales: json['participantesActuales'] is int ? json['participantesActuales'] as int : 0,
      requiereInscripcion: json['requiereInscripcion'] is bool ? json['requiereInscripcion'] as bool : false,
      contactoResponsable: json['contactoResponsable']?.toString() ?? json['contacto_responsable']?.toString(),
      telefono: json['telefono']?.toString(),
      email: json['email']?.toString(),
      etiquetas: tags,
      activo: json['activo'] is bool ? json['activo'] as bool : true,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now() : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now() : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => _$EventoModelToJson(this);

  factory EventoModel.fromEntity(Evento evento) {
    return EventoModel(
      id: evento.id,
      titulo: evento.titulo,
      descripcion: evento.descripcion,
      fecha: evento.fecha,
      hora: evento.hora,
      lugar: evento.lugar,
      categoria: evento.categoria,
      imagenUrl: evento.imagenUrl,
      esRecurrente: evento.esRecurrente,
      frecuenciaRecurrencia: evento.frecuenciaRecurrencia,
      maximoParticipantes: evento.maximoParticipantes,
      participantesActuales: evento.participantesActuales,
      requiereInscripcion: evento.requiereInscripcion,
      contactoResponsable: evento.contactoResponsable,
      telefono: evento.telefono,
      email: evento.email,
      etiquetas: evento.etiquetas,
      activo: evento.activo,
      createdAt: evento.createdAt,
      updatedAt: evento.updatedAt,
    );
  }
}
