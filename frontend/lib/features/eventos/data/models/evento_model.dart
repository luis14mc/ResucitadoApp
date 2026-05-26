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

  factory EventoModel.fromJson(Map<String, dynamic> json) =>
      _$EventoModelFromJson(json);

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
