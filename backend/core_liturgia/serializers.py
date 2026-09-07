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
    EstadoEmision,
)


class CalendarioLiturgicoSerializer(serializers.ModelSerializer):
    tipo_celebracion_label = serializers.CharField(
        source='get_tipo_celebracion_display', read_only=True,
    )
    color_label = serializers.CharField(
        source='get_color_liturgico_display', read_only=True,
    )
    # Canonical camelCase/nested contract consumed by the Flutter client.
    tiempoLiturgico = serializers.CharField(source='tipo_celebracion', read_only=True)
    colorLiturgico = serializers.CharField(source='color_liturgico', read_only=True)
    primeraLectura = serializers.SerializerMethodField()
    segundaLectura = serializers.SerializerMethodField()
    evangelio = serializers.SerializerMethodField()
    salmo = serializers.SerializerMethodField()

    def _reading(self, titulo, referencia, texto):
        return {'titulo': titulo or '', 'referencia': referencia or '', 'texto': texto or ''}

    def get_primeraLectura(self, obj):
        return self._reading('Primera lectura', obj.primera_lectura_cita, obj.primera_lectura_texto)

    def get_segundaLectura(self, obj):
        if not (obj.segunda_lectura_cita or obj.segunda_lectura_texto):
            return None
        return self._reading('Segunda lectura', obj.segunda_lectura_cita, obj.segunda_lectura_texto)

    def get_evangelio(self, obj):
        return self._reading('Evangelio', obj.evangelio_cita, obj.evangelio_texto)

    def get_salmo(self, obj):
        return {
            **self._reading('Salmo', obj.salmo_cita, obj.salmo_texto),
            'respuesta': obj.salmo_respuesta or '',
        }

    class Meta:
        model = CalendarioLiturgico
        fields = (
            'id', 'fecha', 'titulo',
            'tipo_celebracion', 'tipo_celebracion_label',
            'color_liturgico', 'color_label',
            'tiempoLiturgico', 'colorLiturgico', 'primeraLectura',
            'segundaLectura', 'salmo', 'evangelio',
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
    tipo = serializers.SerializerMethodField()
    dia = serializers.CharField(source='get_dia_semana_display', read_only=True)
    sacerdote = serializers.CharField(source='celebrante', read_only=True)
    descripcion = serializers.CharField(source='notas', read_only=True)
    createdAt = serializers.DateTimeField(source='creado_en', read_only=True)
    updatedAt = serializers.DateTimeField(source='actualizado_en', read_only=True)

    def get_tipo(self, obj):
        return 'dominical' if obj.dia_semana == 6 else 'diaria'

    class Meta:
        model = MisaHorario
        fields = (
            'id', 'dia_semana', 'dia_semana_label',
            'dia', 'tipo', 'hora', 'lugar', 'celebrante', 'sacerdote',
            'notas', 'descripcion', 'activo', 'createdAt', 'updatedAt',
        )


class VideoMisaSerializer(serializers.ModelSerializer):
    estado_label = serializers.CharField(
        source='get_estado_display', read_only=True,
    )
    categoria = serializers.SerializerMethodField()
    duracion = serializers.SerializerMethodField()
    urlImagen = serializers.ImageField(source='thumbnail', read_only=True)
    enVivo = serializers.SerializerMethodField()
    vistas = serializers.IntegerField(read_only=True, default=0)
    urlStreaming = serializers.URLField(source='url_facebook', read_only=True)
    videoUrl = serializers.URLField(source='url_facebook', read_only=True)
    youtubeId = serializers.CharField(read_only=True, default='')
    createdAt = serializers.DateTimeField(source='creado_en', read_only=True)
    updatedAt = serializers.DateTimeField(source='actualizado_en', read_only=True)

    def get_categoria(self, obj):
        return 'misas'

    def get_duracion(self, obj):
        if obj.duracion_minutos is None:
            return '00:00'
        return f'{obj.duracion_minutos // 60:02d}:{obj.duracion_minutos % 60:02d}'

    def get_enVivo(self, obj):
        return obj.estado == EstadoEmision.EN_VIVO

    class Meta:
        model = VideoMisa
        fields = (
            'id', 'titulo', 'descripcion', 'fecha_evento',
            'estado', 'estado_label',
            'url_facebook', 'facebook_video_id', 'thumbnail',
            'duracion_minutos', 'destacada', 'categoria', 'duracion',
            'urlImagen', 'enVivo', 'vistas', 'urlStreaming', 'videoUrl',
            'youtubeId', 'createdAt', 'updatedAt',
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
    fechaCelebracion = serializers.DateField(source='fecha_celebracion', read_only=True)
    imagenUrl = serializers.CharField(source='imagen_url', read_only=True)
    createdAt = serializers.DateTimeField(source='creado_en', read_only=True)
    updatedAt = serializers.DateTimeField(source='actualizado_en', read_only=True)

    class Meta:
        model = Santo
        fields = (
            'id', 'nombre', 'titulo', 'fecha_celebracion', 'biografia',
            'festividad', 'patrono', 'oracion', 'imagen_url', 'atributos',
            'created_at', 'updated_at', 'fechaCelebracion', 'imagenUrl',
            'createdAt', 'updatedAt',
        )


class EventoSerializer(serializers.ModelSerializer):
    id = serializers.CharField(read_only=True)
    created_at = serializers.DateTimeField(source='creado_en', read_only=True)
    updated_at = serializers.DateTimeField(source='actualizado_en', read_only=True)
    imagenUrl = serializers.CharField(source='imagen_url', read_only=True)
    esRecurrente = serializers.BooleanField(source='es_recurrente', read_only=True)
    frecuenciaRecurrencia = serializers.CharField(source='frecuencia_recurrencia', read_only=True)
    maximoParticipantes = serializers.IntegerField(source='maximo_participantes', read_only=True)
    participantesActuales = serializers.IntegerField(source='participantes_actuales', read_only=True)
    requiereInscripcion = serializers.BooleanField(source='requiere_inscripcion', read_only=True)
    contactoResponsable = serializers.CharField(source='contacto_responsable', read_only=True)
    createdAt = serializers.DateTimeField(source='creado_en', read_only=True)
    updatedAt = serializers.DateTimeField(source='actualizado_en', read_only=True)

    class Meta:
        model = Evento
        fields = (
            'id', 'titulo', 'descripcion', 'fecha', 'hora', 'lugar',
            'categoria', 'imagen_url', 'es_recurrente', 'frecuencia_recurrencia',
            'maximo_participantes', 'participantes_actuales', 'requiere_inscripcion',
            'contacto_responsable', 'telefono', 'email', 'etiquetas', 'activo',
            'created_at', 'updated_at',
            'imagenUrl', 'esRecurrente', 'frecuenciaRecurrencia',
            'maximoParticipantes', 'participantesActuales',
            'requiereInscripcion', 'contactoResponsable', 'createdAt', 'updatedAt',
        )


class ParroquiaInfoSerializer(serializers.ModelSerializer):
    id = serializers.CharField(read_only=True)
    actualizado_en = serializers.DateTimeField(read_only=True)
    actualizadoEn = serializers.DateTimeField(source='actualizado_en', read_only=True)

    class Meta:
        model = ParroquiaInfo
        fields = (
            'id', 'nombre', 'historia', 'mision', 'vision', 'valores',
            'imagenes', 'direccion', 'telefono', 'email', 'actualizado_en',
            'actualizadoEn',
        )


class OficinaInfoSerializer(serializers.ModelSerializer):
    id = serializers.CharField(read_only=True)
    actualizado_en = serializers.DateTimeField(read_only=True)
    actualizadoEn = serializers.DateTimeField(source='actualizado_en', read_only=True)
    horarioAtencion = serializers.JSONField(source='horarios', read_only=True)
    ubicacion = serializers.CharField(source='direccion', read_only=True)
    contacto = serializers.SerializerMethodField()
    coordenadas = serializers.SerializerMethodField()

    def get_contacto(self, obj):
        return {'telefono': obj.telefono, 'email': obj.email}

    def get_coordenadas(self, obj):
        return {'latitud': obj.latitud, 'longitud': obj.longitud}

    class Meta:
        model = OficinaInfo
        fields = (
            'id', 'direccion', 'telefono', 'email', 'horarios', 'servicios',
            'latitud', 'longitud', 'actualizado_en', 'actualizadoEn',
            'horarioAtencion', 'ubicacion', 'contacto', 'coordenadas',
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
