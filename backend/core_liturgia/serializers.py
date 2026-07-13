"""
core_liturgia.serializers
DRF serializers consumidos por el DioClient de Flutter.
"""
from rest_framework import serializers
from .models import (
    CalendarioLiturgico,
    MisaHorario,
    VideoMisa,
    IntencionOracion,
    Santo,
    Evento,
    ParroquiaInfo,
    OficinaInfo,
    Oracion,
    OracionSeccion,
)


class CalendarioLiturgicoSerializer(serializers.ModelSerializer):
    tipo_celebracion_label = serializers.CharField(
        source='get_tipo_celebracion_display', read_only=True,
    )
    color_label = serializers.CharField(
        source='get_color_liturgico_display', read_only=True,
    )

    class Meta:
        model = CalendarioLiturgico
        fields = (
            'id', 'fecha', 'titulo',
            'tipo_celebracion', 'tipo_celebracion_label',
            'color_liturgico', 'color_label',
            'primera_lectura_cita', 'primera_lectura_texto',
            'salmo_cita', 'salmo_respuesta', 'salmo_texto',
            'segunda_lectura_cita', 'segunda_lectura_texto',
            'aclamacion_evangelio', 'evangelio_cita', 'evangelio_texto',
            'reflexion', 'fuente', 'actualizado_en',
        )


class MisaHorarioSerializer(serializers.ModelSerializer):
    dia_semana_label = serializers.CharField(
        source='get_dia_semana_display', read_only=True,
    )

    class Meta:
        model = MisaHorario
        fields = (
            'id', 'dia_semana', 'dia_semana_label',
            'hora', 'lugar', 'celebrante', 'notas', 'activo',
        )


class VideoMisaSerializer(serializers.ModelSerializer):
    estado_label = serializers.CharField(
        source='get_estado_display', read_only=True,
    )

    class Meta:
        model = VideoMisa
        fields = (
            'id', 'titulo', 'descripcion', 'fecha_evento',
            'estado', 'estado_label',
            'url_facebook', 'facebook_video_id', 'thumbnail',
            'duracion_minutos', 'destacada',
        )


class IntencionOracionCreateSerializer(serializers.ModelSerializer):
    """Serializer público — solo expone campos que el fiel puede enviar."""

    class Meta:
        model = IntencionOracion
        fields = ('nombre', 'contacto', 'intencion', 'es_anonima', 'es_publica')

    def validate_intencion(self, value):
        value = value.strip()
        if len(value) < 5:
            raise serializers.ValidationError(
                'La intención es demasiado corta.'
            )
        if len(value) > 2000:
            raise serializers.ValidationError(
                'La intención excede el máximo permitido (2000 caracteres).'
            )
        return value


class IntencionOracionPublicaSerializer(serializers.ModelSerializer):
    """Serializer para el muro público (solo intenciones aprobadas)."""

    class Meta:
        model = IntencionOracion
        fields = ('id', 'nombre', 'intencion', 'creado_en')
        read_only_fields = fields


class SantoSerializer(serializers.ModelSerializer):
    id = serializers.CharField(read_only=True)
    created_at = serializers.DateTimeField(source='creado_en', read_only=True)
    updated_at = serializers.DateTimeField(source='actualizado_en', read_only=True)

    class Meta:
        model = Santo
        fields = (
            'id', 'nombre', 'titulo', 'fecha_celebracion', 'biografia',
            'festividad', 'patrono', 'oracion', 'imagen_url', 'atributos',
            'created_at', 'updated_at',
        )


class EventoSerializer(serializers.ModelSerializer):
    id = serializers.CharField(read_only=True)
    created_at = serializers.DateTimeField(source='creado_en', read_only=True)
    updated_at = serializers.DateTimeField(source='actualizado_en', read_only=True)

    class Meta:
        model = Evento
        fields = (
            'id', 'titulo', 'descripcion', 'fecha', 'hora', 'lugar',
            'categoria', 'imagen_url', 'es_recurrente', 'frecuencia_recurrencia',
            'maximo_participantes', 'participantes_actuales', 'requiere_inscripcion',
            'contacto_responsable', 'telefono', 'email', 'etiquetas', 'activo',
            'created_at', 'updated_at',
        )


class ParroquiaInfoSerializer(serializers.ModelSerializer):
    id = serializers.CharField(read_only=True)
    actualizado_en = serializers.DateTimeField(read_only=True)

    class Meta:
        model = ParroquiaInfo
        fields = (
            'id', 'nombre', 'historia', 'mision', 'vision', 'valores',
            'imagenes', 'direccion', 'telefono', 'email', 'actualizado_en',
        )


class OficinaInfoSerializer(serializers.ModelSerializer):
    id = serializers.CharField(read_only=True)
    actualizado_en = serializers.DateTimeField(read_only=True)

    class Meta:
        model = OficinaInfo
        fields = (
            'id', 'direccion', 'telefono', 'email', 'horarios', 'servicios',
            'latitud', 'longitud', 'actualizado_en',
        )


# ============================================================
# Serializadores de Oraciones
# ============================================================
class OracionSeccionSerializer(serializers.ModelSerializer):
    class Meta:
        model = OracionSeccion
        fields = ('id', 'titulo', 'contenido', 'orden')


class OracionSerializer(serializers.ModelSerializer):
    id = serializers.CharField(read_only=True)
    created_at = serializers.DateTimeField(source='creado_en', read_only=True)
    updated_at = serializers.DateTimeField(source='actualizado_en', read_only=True)

    class Meta:
        model = Oracion
        fields = (
            'id', 'titulo', 'slug', 'categoria', 'descripcion', 'contenido',
            'orden', 'activo', 'destacada', 'duracion_estimada',
            'created_at', 'updated_at',
        )


class OracionDetalleSerializer(serializers.ModelSerializer):
    id = serializers.CharField(read_only=True)
    secciones = OracionSeccionSerializer(many=True, read_only=True)
    created_at = serializers.DateTimeField(source='creado_en', read_only=True)
    updated_at = serializers.DateTimeField(source='actualizado_en', read_only=True)

    class Meta:
        model = Oracion
        fields = (
            'id', 'titulo', 'slug', 'categoria', 'descripcion', 'contenido',
            'secciones', 'orden', 'activo', 'destacada', 'duracion_estimada',
            'created_at', 'updated_at',
        )

