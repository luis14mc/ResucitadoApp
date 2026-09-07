"""
core_liturgia.models
ResucitadoApp v2 · Parroquia Cristo Resucitado · Tegucigalpa, Honduras

Modelos centrales del backend:
- CalendarioLiturgico  -> Lecturas + salmo + evangelio + tipo + color (caché diaria)
- MisaHorario          -> Horarios de misas regulares por día de la semana
- VideoMisa            -> Emisiones de Facebook Live (transmisión y grabaciones)
- IntencionOracion     -> Buzón abierto para que cualquier fiel envíe peticiones
"""
import uuid

from django.db import models
from django.db.models import Q
from django.core.validators import MinValueValidator, MaxValueValidator
from django.utils import timezone


# ============================================================
# Choices reutilizables
# ============================================================
class ColorLiturgico(models.TextChoices):
    BLANCO = 'blanco', 'Blanco'
    ROJO = 'rojo', 'Rojo'
    VERDE = 'verde', 'Verde'
    MORADO = 'morado', 'Morado'
    ROSA = 'rosa', 'Rosa'
    DORADO = 'dorado', 'Dorado'
    NEGRO = 'negro', 'Negro'


class TipoCelebracion(models.TextChoices):
    FERIA = 'feria', 'Feria'
    MEMORIA_LIBRE = 'memoria_libre', 'Memoria libre'
    MEMORIA_OBLIGATORIA = 'memoria_obligatoria', 'Memoria obligatoria'
    FIESTA = 'fiesta', 'Fiesta'
    SOLEMNIDAD = 'solemnidad', 'Solemnidad'
    DOMINGO = 'domingo', 'Domingo'


class DiaSemana(models.IntegerChoices):
    LUNES = 0, 'Lunes'
    MARTES = 1, 'Martes'
    MIERCOLES = 2, 'Miércoles'
    JUEVES = 3, 'Jueves'
    VIERNES = 4, 'Viernes'
    SABADO = 5, 'Sábado'
    DOMINGO = 6, 'Domingo'


class EstadoEmision(models.TextChoices):
    PROGRAMADA = 'programada', 'Programada'
    EN_VIVO = 'en_vivo', 'En vivo'
    GRABADA = 'grabada', 'Grabada'
    CANCELADA = 'cancelada', 'Cancelada'


class EstadoIntencion(models.TextChoices):
    PENDIENTE = 'pendiente', 'Pendiente'
    EN_ORACION = 'en_oracion', 'En oración'
    ATENDIDA = 'atendida', 'Atendida'
    DESCARTADA = 'descartada', 'Descartada (spam/ofensiva)'


# ============================================================
# CalendarioLiturgico
# ============================================================
class CalendarioLiturgico(models.Model):
    """
    Caché diaria de lecturas litúrgicas.
    Una fila por fecha. Se alimenta por:
      1. El proxy automático (services.lecturas_proxy.LecturasProxyService).
      2. Edición manual del admin (la Pastoral puede corregir/sobrescribir).
    """
    fecha = models.DateField(
        unique=True,
        verbose_name='Fecha litúrgica',
        help_text='Una sola fila por día.',
    )
    tipo_celebracion = models.CharField(
        max_length=24,
        choices=TipoCelebracion.choices,
        default=TipoCelebracion.FERIA,
    )
    color_liturgico = models.CharField(
        max_length=12,
        choices=ColorLiturgico.choices,
        default=ColorLiturgico.VERDE,
    )
    titulo = models.CharField(
        max_length=255,
        blank=True,
        help_text='Ej: "III Domingo del Tiempo Ordinario", "San Juan Bautista".',
    )
    # Lecturas
    primera_lectura_cita = models.CharField(max_length=120, blank=True)
    primera_lectura_texto = models.TextField(blank=True)

    salmo_cita = models.CharField(max_length=120, blank=True)
    salmo_respuesta = models.CharField(max_length=255, blank=True)
    salmo_texto = models.TextField(blank=True)

    segunda_lectura_cita = models.CharField(max_length=120, blank=True)
    segunda_lectura_texto = models.TextField(blank=True)

    aclamacion_evangelio = models.TextField(
        blank=True,
        help_text='Aleluya / Versículo antes del Evangelio.',
    )
    evangelio_cita = models.CharField(max_length=120, blank=True)
    evangelio_texto = models.TextField(blank=True)

    # Reflexión opcional (la Pastoral puede añadirla)
    reflexion = models.TextField(blank=True)

    # Trazabilidad del proxy
    fuente = models.CharField(
        max_length=120,
        blank=True,
        help_text='URL o nombre de la fuente desde la que se importó.',
    )
    importado_en = models.DateTimeField(null=True, blank=True)
    editado_manualmente = models.BooleanField(
        default=False,
        help_text='Si está marcado, el proxy NO sobrescribirá esta fila.',
    )

    creado_en = models.DateTimeField(auto_now_add=True)
    actualizado_en = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'Calendario Litúrgico'
        verbose_name_plural = 'Calendario Litúrgico'
        ordering = ['-fecha']
        indexes = [
            models.Index(fields=['-fecha']),
            models.Index(fields=['color_liturgico']),
        ]

    def __str__(self):
        return f'{self.fecha:%Y-%m-%d} · {self.titulo or self.get_tipo_celebracion_display()}'


# ============================================================
# MisaHorario
# ============================================================
class MisaHorario(models.Model):
    """
    Horario regular de misas por día de la semana.
    Permite múltiples misas por día y diferenciar templo / capilla.
    """
    dia_semana = models.IntegerField(choices=DiaSemana.choices)
    hora = models.TimeField()
    lugar = models.CharField(
        max_length=120,
        default='Templo Principal',
        help_text='Templo Principal, Capilla, Adoración, etc.',
    )
    celebrante = models.CharField(
        max_length=120,
        blank=True,
        help_text='Opcional. Si rota semana a semana, dejar vacío.',
    )
    notas = models.CharField(max_length=255, blank=True)
    activo = models.BooleanField(default=True)

    creado_en = models.DateTimeField(auto_now_add=True)
    actualizado_en = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'Horario de Misa'
        verbose_name_plural = 'Horarios de Misas'
        ordering = ['dia_semana', 'hora']
        indexes = [models.Index(fields=['dia_semana', 'hora'])]

    def __str__(self):
        return f'{self.get_dia_semana_display()} · {self.hora:%H:%M} · {self.lugar}'


# ============================================================
# VideoMisa  (Facebook Live + grabaciones)
# ============================================================
class VideoMisa(models.Model):
    """
    Emisiones / grabaciones de misas en Facebook Live.
    Permite mostrar en Flutter:
      - "En vivo ahora"
      - "Próxima transmisión"
      - "Misas anteriores" (replay)
    """
    titulo = models.CharField(max_length=180)
    descripcion = models.TextField(blank=True)
    fecha_evento = models.DateTimeField(
        help_text='Inicio programado o real de la transmisión.',
    )
    estado = models.CharField(
        max_length=12,
        choices=EstadoEmision.choices,
        default=EstadoEmision.PROGRAMADA,
    )
    url_facebook = models.URLField(
        max_length=500,
        help_text='URL de la publicación o transmisión en Facebook.',
    )
    facebook_video_id = models.CharField(
        max_length=64,
        blank=True,
        help_text='ID del video en Facebook (para embed).',
    )
    thumbnail = models.ImageField(
        upload_to='videos/thumbs/',
        blank=True,
        null=True,
    )
    duracion_minutos = models.PositiveIntegerField(
        null=True,
        blank=True,
        help_text='Llenar cuando ya esté grabada.',
    )
    destacada = models.BooleanField(
        default=False,
        help_text='Mostrar como destacada en el home de Flutter.',
    )

    creado_en = models.DateTimeField(auto_now_add=True)
    actualizado_en = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'Video de Misa'
        verbose_name_plural = 'Videos de Misas'
        ordering = ['-fecha_evento']
        indexes = [
            models.Index(fields=['-fecha_evento']),
            models.Index(fields=['estado']),
        ]

    def __str__(self):
        return f'[{self.get_estado_display()}] {self.titulo} ({self.fecha_evento:%Y-%m-%d %H:%M})'


# ============================================================
# IntencionOracion  (POST público abierto)
# ============================================================
class IntencionOracion(models.Model):
    """
    Buzón abierto: cualquier fiel puede enviar una intención desde la app
    SIN necesidad de loguearse. La Pastoral las modera desde /admin.
    """
    nombre = models.CharField(
        max_length=120,
        blank=True,
        help_text='Opcional. El fiel puede enviarla anónima.',
    )
    contacto = models.CharField(
        max_length=120,
        blank=True,
        help_text='Email o teléfono — opcional, solo para seguimiento privado.',
    )
    intencion = models.TextField(
        help_text='Texto de la petición / acción de gracias.',
    )
    es_anonima = models.BooleanField(default=True)
    es_publica = models.BooleanField(
        default=False,
        help_text='Si está marcada, puede mostrarse en el muro público de la app.',
    )
    estado = models.CharField(
        max_length=16,
        choices=EstadoIntencion.choices,
        default=EstadoIntencion.PENDIENTE,
    )

    # Para anti-abuso (rate limit en views) y trazabilidad
    ip_origen = models.GenericIPAddressField(null=True, blank=True)
    user_agent = models.CharField(max_length=255, blank=True)

    creado_en = models.DateTimeField(auto_now_add=True)
    actualizado_en = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'Intención de Oración'
        verbose_name_plural = 'Intenciones de Oración'
        ordering = ['-creado_en']
        indexes = [
            models.Index(fields=['-creado_en']),
            models.Index(fields=['estado']),
        ]

    def __str__(self):
        autor = self.nombre or 'Anónimo'
        return f'{autor} · {self.intencion[:60]}...'


# ============================================================
# Santo
# ============================================================
class Santo(models.Model):
    nombre = models.CharField(max_length=120)
    titulo = models.CharField(max_length=180, blank=True)
    fecha_celebracion = models.DateField(
        help_text='Día y mes de la celebración (el año se puede ignorar o usar el actual).',
    )
    biografia = models.TextField(blank=True)
    festividad = models.CharField(max_length=120, blank=True)
    patrono = models.CharField(max_length=120, blank=True)
    oracion = models.TextField(blank=True)
    imagen_url = models.CharField(max_length=255, blank=True, null=True)
    atributos = models.JSONField(default=list, blank=True)
    
    creado_en = models.DateTimeField(auto_now_add=True)
    actualizado_en = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'Santo'
        verbose_name_plural = 'Santos'
        ordering = ['fecha_celebracion']

    def __str__(self):
        return self.nombre


# ============================================================
# Evento
# ============================================================
class Evento(models.Model):
    class Categoria(models.TextChoices):
        LITURGIA = 'liturgia', 'Liturgia'
        COMUNIDAD = 'comunidad', 'Comunidad'
        JUVENTUD = 'juventud', 'Juventud'
        FORMACION = 'formacion', 'Formación'
        MISION = 'mision', 'Misión'

    titulo = models.CharField(max_length=180)
    descripcion = models.TextField(blank=True)
    fecha = models.DateField()
    hora = models.CharField(max_length=30)
    lugar = models.CharField(max_length=120)
    categoria = models.CharField(
        max_length=20,
        choices=Categoria.choices,
        default=Categoria.COMUNIDAD,
    )
    imagen_url = models.CharField(max_length=255, blank=True, null=True)
    es_recurrente = models.BooleanField(default=False)
    frecuencia_recurrencia = models.CharField(max_length=120, blank=True, null=True)
    maximo_participantes = models.PositiveIntegerField(blank=True, null=True)
    participantes_actuales = models.PositiveIntegerField(default=0)
    requiere_inscripcion = models.BooleanField(default=False)
    contacto_responsable = models.CharField(max_length=120, blank=True, null=True)
    telefono = models.CharField(max_length=30, blank=True, null=True)
    email = models.CharField(max_length=120, blank=True, null=True)
    etiquetas = models.JSONField(default=list, blank=True)
    activo = models.BooleanField(default=True)
    
    creado_en = models.DateTimeField(auto_now_add=True)
    actualizado_en = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'Evento'
        verbose_name_plural = 'Eventos'
        ordering = ['fecha', 'hora']
        constraints = [
            models.CheckConstraint(
                check=Q(participantes_actuales__gte=0),
                name='evento_participantes_no_negativos',
            ),
        ]

    def __str__(self):
        return self.titulo


class EventoInscripcion(models.Model):
    """Public registration record used to make event writes idempotent.

    The mobile app does not require an account, so the generated UUID is the
    cancellation token returned to the caller.  The optional idempotency key
    prevents retries from incrementing the event counter twice.
    """

    evento = models.ForeignKey(
        Evento,
        related_name='inscripciones',
        on_delete=models.CASCADE,
    )
    participante_id = models.UUIDField(default=uuid.uuid4, unique=True, editable=False)
    idempotency_key = models.CharField(max_length=128, blank=True)
    nombre = models.CharField(max_length=120, blank=True)
    email = models.EmailField(max_length=254, blank=True)
    telefono = models.CharField(max_length=30, blank=True)
    notas = models.CharField(max_length=500, blank=True)
    datos = models.JSONField(default=dict, blank=True)
    ip_origen = models.GenericIPAddressField(null=True, blank=True)
    activa = models.BooleanField(default=True)
    creado_en = models.DateTimeField(auto_now_add=True)
    actualizado_en = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'Inscripción a evento'
        verbose_name_plural = 'Inscripciones a eventos'
        ordering = ['-creado_en']
        constraints = [
            models.UniqueConstraint(
                fields=['evento', 'idempotency_key'],
                condition=~Q(idempotency_key=''),
                name='evento_idempotencia_unica',
            ),
        ]

    def __str__(self):
        return f'{self.evento_id} · {self.participante_id}'


# ============================================================
# ParroquiaInfo
# ============================================================
class ParroquiaInfo(models.Model):
    nombre = models.CharField(max_length=120, default='Parroquia Cristo Resucitado')
    historia = models.TextField(blank=True)
    mision = models.TextField(blank=True)
    vision = models.TextField(blank=True)
    valores = models.JSONField(default=list, blank=True)
    imagenes = models.JSONField(default=list, blank=True)
    direccion = models.TextField(blank=True)
    telefono = models.CharField(max_length=30, blank=True)
    email = models.CharField(max_length=120, blank=True)
    
    actualizado_en = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'Información Parroquial'
        verbose_name_plural = 'Información Parroquial'

    def __str__(self):
        return self.nombre


# ============================================================
# OficinaInfo
# ============================================================
class OficinaInfo(models.Model):
    direccion = models.TextField(blank=True)
    telefono = models.CharField(max_length=30, blank=True)
    email = models.CharField(max_length=120, blank=True)
    horarios = models.JSONField(default=dict, blank=True)
    servicios = models.JSONField(default=list, blank=True)
    latitud = models.FloatField(blank=True, null=True)
    longitud = models.FloatField(blank=True, null=True)
    
    actualizado_en = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'Información de Oficina'
        verbose_name_plural = 'Información de Oficina'

    def __str__(self):
        return 'Oficina Parroquial'


# ============================================================
# Oraciones y Secciones
# ============================================================
class CategoriaOracion(models.TextChoices):
    LECTIO_DIVINA = 'lectio_divina', 'Lectio Divina'
    LITURGIA_HORAS = 'liturgia_horas', 'Liturgia de las Horas'
    ROSARIO = 'rosario', 'Santo Rosario'
    CORONILLA = 'coronilla', 'Coronilla'
    BASICAS = 'basicas', 'Oraciones Básicas'
    INTENCIONES = 'intenciones', 'Oraciones por Intención'
    NOVENAS = 'novenas', 'Novenas'


class Oracion(models.Model):
    titulo = models.CharField(max_length=180)
    slug = models.SlugField(max_length=200, unique=True)
    categoria = models.CharField(
        max_length=30,
        choices=CategoriaOracion.choices,
        default=CategoriaOracion.BASICAS,
    )
    descripcion = models.TextField(blank=True)
    contenido = models.TextField(blank=True, null=True, help_text="Contenido de la oración si es de texto simple.")
    orden = models.IntegerField(default=0)
    activo = models.BooleanField(default=True)
    destacada = models.BooleanField(default=False)
    duracion_estimada = models.PositiveIntegerField(default=5, help_text="Duración estimada de la oración en minutos.")

    creado_en = models.DateTimeField(auto_now_add=True)
    actualizado_en = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'Oración'
        verbose_name_plural = 'Oraciones'
        ordering = ['categoria', 'orden', 'titulo']
        indexes = [
            models.Index(fields=['categoria']),
            models.Index(fields=['slug']),
            models.Index(fields=['activo']),
            models.Index(fields=['destacada']),
        ]

    def __str__(self):
        return f'{self.titulo} ({self.get_categoria_display()})'


class OracionSeccion(models.Model):
    oracion = models.ForeignKey(
        Oracion,
        related_name='secciones',
        on_delete=models.CASCADE,
    )
    titulo = models.CharField(max_length=150)
    contenido = models.TextField()
    orden = models.PositiveIntegerField(default=0)

    class Meta:
        verbose_name = 'Sección de Oración'
        verbose_name_plural = 'Secciones de Oraciones'
        ordering = ['orden']

    def __str__(self):
        return f'{self.oracion.titulo} - {self.titulo} ({self.orden})'
