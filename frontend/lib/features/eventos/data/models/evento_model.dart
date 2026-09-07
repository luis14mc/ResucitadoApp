import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/evento.dart';
import '../../../../core/utils/json_utils.dart';

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
    } else if (catStr.contains('form') ||
        catStr.contains('cateq') ||
        catStr.contains('retir')) {
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
      fecha: JsonUtils.date(json, ['fecha']) ?? DateTime.now(),
      hora: JsonUtils.string(json, ['hora']),
      lugar: JsonUtils.string(json, ['lugar']),
      categoria: catEnum,
      imagenUrl:
          json['imagenUrl']?.toString() ?? json['imagen_url']?.toString(),
      esRecurrente: JsonUtils.boolean(json, ['esRecurrente', 'es_recurrente']),
      frecuenciaRecurrencia: JsonUtils.string(
          json, ['frecuenciaRecurrencia', 'frecuencia_recurrencia'],
          fallback: ''),
      maximoParticipantes: JsonUtils.value(
                  json, ['maximoParticipantes', 'maximo_participantes']) ==
              null
          ? null
          : JsonUtils.integer(
              json, ['maximoParticipantes', 'maximo_participantes']),
      participantesActuales: JsonUtils.integer(
          json, ['participantesActuales', 'participantes_actuales']),
      requiereInscripcion: JsonUtils.boolean(
          json, ['requiereInscripcion', 'requiere_inscripcion']),
      contactoResponsable: JsonUtils.string(
          json, ['contactoResponsable', 'contacto_responsable'],
          fallback: ''),
      telefono: JsonUtils.string(json, ['telefono'], fallback: ''),
      email: JsonUtils.string(json, ['email'], fallback: ''),
      etiquetas: tags,
      activo: JsonUtils.boolean(json, ['activo'], fallback: true),
      createdAt:
          JsonUtils.date(json, ['createdAt', 'created_at']) ?? DateTime.now(),
      updatedAt:
          JsonUtils.date(json, ['updatedAt', 'updated_at']) ?? DateTime.now(),
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
