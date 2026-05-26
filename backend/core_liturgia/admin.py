"""
core_liturgia.admin
Panel de administración para la Pastoral de Medios de Comunicación.
"""
from django.contrib import admin
from django.utils.html import format_html
from .models import (
    CalendarioLiturgico,
    MisaHorario,
    VideoMisa,
    IntencionOracion,
)


@admin.register(CalendarioLiturgico)
class CalendarioLiturgicoAdmin(admin.ModelAdmin):
    list_display = (
        'fecha', 'titulo', 'tipo_celebracion',
        'color_badge', 'editado_manualmente', 'actualizado_en',
    )
    list_filter = ('tipo_celebracion', 'color_liturgico', 'editado_manualmente')
    search_fields = ('titulo', 'primera_lectura_cita', 'evangelio_cita')
    date_hierarchy = 'fecha'
    readonly_fields = ('fuente', 'importado_en', 'creado_en', 'actualizado_en')

    fieldsets = (
        ('Identificación', {
            'fields': ('fecha', 'titulo', 'tipo_celebracion', 'color_liturgico'),
        }),
        ('Primera Lectura', {
            'fields': ('primera_lectura_cita', 'primera_lectura_texto'),
        }),
        ('Salmo', {
            'fields': ('salmo_cita', 'salmo_respuesta', 'salmo_texto'),
        }),
        ('Segunda Lectura', {
            'classes': ('collapse',),
            'fields': ('segunda_lectura_cita', 'segunda_lectura_texto'),
        }),
        ('Evangelio', {
            'fields': ('aclamacion_evangelio', 'evangelio_cita', 'evangelio_texto'),
        }),
        ('Reflexión', {
            'classes': ('collapse',),
            'fields': ('reflexion',),
        }),
        ('Proxy / Trazabilidad', {
            'classes': ('collapse',),
            'fields': ('fuente', 'importado_en', 'editado_manualmente',
                       'creado_en', 'actualizado_en'),
        }),
    )

    @admin.display(description='Color', ordering='color_liturgico')
    def color_badge(self, obj):
        palette = {
            'blanco': '#f5f5f5', 'rojo': '#c0392b', 'verde': '#27ae60',
            'morado': '#8e44ad', 'rosa': '#e91e63', 'dorado': '#E3A822',
            'negro': '#222',
        }
        bg = palette.get(obj.color_liturgico, '#999')
        fg = '#222' if obj.color_liturgico == 'blanco' else '#fff'
        return format_html(
            '<span style="background:{};color:{};padding:2px 8px;'
            'border-radius:8px;font-size:11px;">{}</span>',
            bg, fg, obj.get_color_liturgico_display(),
        )


@admin.register(MisaHorario)
class MisaHorarioAdmin(admin.ModelAdmin):
    list_display = ('dia_semana', 'hora', 'lugar', 'celebrante', 'activo')
    list_filter = ('dia_semana', 'lugar', 'activo')
    search_fields = ('lugar', 'celebrante', 'notas')
    list_editable = ('activo',)


@admin.register(VideoMisa)
class VideoMisaAdmin(admin.ModelAdmin):
    list_display = ('titulo', 'fecha_evento', 'estado',
                    'destacada', 'duracion_minutos')
    list_filter = ('estado', 'destacada')
    search_fields = ('titulo', 'descripcion', 'facebook_video_id')
    date_hierarchy = 'fecha_evento'
    list_editable = ('destacada',)


@admin.register(IntencionOracion)
class IntencionOracionAdmin(admin.ModelAdmin):
    list_display = ('creado_en', 'nombre_o_anonimo', 'estado',
                    'es_publica', 'intencion_corta')
    list_filter = ('estado', 'es_publica', 'es_anonima')
    search_fields = ('nombre', 'contacto', 'intencion')
    date_hierarchy = 'creado_en'
    list_editable = ('estado', 'es_publica')
    readonly_fields = ('ip_origen', 'user_agent', 'creado_en', 'actualizado_en')

    @admin.display(description='Autor')
    def nombre_o_anonimo(self, obj):
        return obj.nombre if (obj.nombre and not obj.es_anonima) else 'Anónimo'

    @admin.display(description='Intención')
    def intencion_corta(self, obj):
        return (obj.intencion[:80] + '…') if len(obj.intencion) > 80 else obj.intencion
