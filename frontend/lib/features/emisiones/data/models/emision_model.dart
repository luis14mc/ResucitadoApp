import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/emision.dart';
import '../../../../core/utils/json_utils.dart';

part 'emision_model.g.dart';

/// Model para serialización JSON de Emision
@JsonSerializable()
class EmisionModel extends Emision {
  const EmisionModel({
    required super.id,
    required super.titulo,
    required super.descripcion,
    required super.categoria,
    required super.duracion,
    required super.fecha,
    required super.thumbnail,
    required super.enVivo,
    required super.vistas,
    super.videoUrl,
    super.youtubeId,
  });

  factory EmisionModel.fromJson(Map<String, dynamic> json) {
    // Determine duration
    String durStr = '00:00';
    if (json['horarioInicio'] != null && json['horarioFin'] != null) {
      durStr = '${json['horarioInicio']} - ${json['horarioFin']}';
    } else if (json['duracion'] != null) {
      durStr = json['duracion'].toString();
    }

    return EmisionModel(
      id: (json['id'] ?? '').toString(),
      titulo: (json['titulo'] ?? '').toString(),
      descripcion: (json['descripcion'] ?? '').toString(),
      categoria: (json['categoria'] ?? '').toString(),
      duracion: durStr,
      fecha:
          JsonUtils.date(json, ['createdAt', 'created_at', 'fecha_evento']) ??
              DateTime.now(),
      thumbnail: JsonUtils.string(
        json,
        ['urlImagen', 'thumbnail', 'url_imagen'],
        fallback: 'assets/images/Logo_PCR.png',
      ),
      enVivo: JsonUtils.boolean(json, ['enVivo', 'en_vivo']),
      vistas: JsonUtils.integer(json, ['vistas']),
      videoUrl: JsonUtils.string(
          json, ['urlStreaming', 'videoUrl', 'url_streaming', 'video_url'],
          fallback: ''),
      youtubeId:
          JsonUtils.string(json, ['youtubeId', 'youtube_id'], fallback: ''),
    );
  }

  Map<String, dynamic> toJson() => _$EmisionModelToJson(this);

  /// Crea un EmisionModel desde una Entity
  factory EmisionModel.fromEntity(Emision emision) {
    return EmisionModel(
      id: emision.id,
      titulo: emision.titulo,
      descripcion: emision.descripcion,
      categoria: emision.categoria,
      duracion: emision.duracion,
      fecha: emision.fecha,
      thumbnail: emision.thumbnail,
      enVivo: emision.enVivo,
      vistas: emision.vistas,
      videoUrl: emision.videoUrl,
      youtubeId: emision.youtubeId,
    );
  }

  /// Convierte a Entity
  Emision toEntity() {
    return Emision(
      id: id,
      titulo: titulo,
      descripcion: descripcion,
      categoria: categoria,
      duracion: duracion,
      fecha: fecha,
      thumbnail: thumbnail,
      enVivo: enVivo,
      vistas: vistas,
      videoUrl: videoUrl,
      youtubeId: youtubeId,
    );
  }
}
