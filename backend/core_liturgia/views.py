"""
core_liturgia.views
Endpoints REST consumidos por la app Flutter.

Filosofía:
- GETs abiertos a todo público (los fieles no se loguean).
- POST de IntencionOracion también abierto, pero con rate limiting básico
  por IP y validación anti-abuso.
"""
from datetime import date
from django.utils import timezone
from django.db.models import Q
from rest_framework import viewsets, mixins, status, generics
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import (
    CalendarioLiturgico, MisaHorario, VideoMisa, IntencionOracion,
    EstadoEmision, Santo, Evento, ParroquiaInfo, OficinaInfo,
    Oracion,
)
from .serializers import (
    CalendarioLiturgicoSerializer,
    MisaHorarioSerializer,
    VideoMisaSerializer,
    IntencionOracionCreateSerializer,
    IntencionOracionPublicaSerializer,
    SantoSerializer,
    EventoSerializer,
    ParroquiaInfoSerializer,
    OficinaInfoSerializer,
    OracionSerializer,
    OracionDetalleSerializer,
)
from .services.lecturas_proxy import LecturasProxyService


# ============================================================
# Stubs temporales — features que aún se migran de Express
# ============================================================
# Devuelven JSON vacío válido para que el frontend no quiebre.
# Cuando se modele cada feature (Santo, Evento, Oficina, Parroquia)
# se reemplazan por sus ViewSets DRF correspondientes.

class EmptyListView(APIView):
    """Devuelve [] con 200 OK. Stub para listados."""
    def get(self, request, *args, **kwargs):
        return Response([])


class EmptyDictView(APIView):
    """Devuelve {} con 200 OK. Stub para detalle/info."""
    def get(self, request, *args, **kwargs):
        return Response({})


def _client_ip(request):
    xff = request.META.get('HTTP_X_FORWARDED_FOR')
    return xff.split(',')[0].strip() if xff else request.META.get('REMOTE_ADDR')


# ============================================================
# Calendario Litúrgico
# ============================================================
class CalendarioLiturgicoViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = CalendarioLiturgico.objects.all()
    serializer_class = CalendarioLiturgicoSerializer
    lookup_field = 'fecha'

    @action(detail=False, methods=['get'], url_path='hoy')
    def hoy(self, request):
        """GET /api/v1/calendario/hoy/  -> lecturas del día actual."""
        target = timezone.localdate()
        obj = CalendarioLiturgico.objects.filter(fecha=target).first()
        if not obj:
            # Si la caché está vacía para hoy, intentamos importarla on-demand.
            try:
                obj = LecturasProxyService().fetch_and_cache(target)
            except Exception:  # noqa: BLE001
                return Response(
                    {'detail': 'Lecturas no disponibles aún para hoy.'},
                    status=status.HTTP_404_NOT_FOUND,
                )
        return Response(self.get_serializer(obj).data)

    @action(detail=False, methods=['get'], url_path=r'fecha/(?P<ymd>\d{4}-\d{2}-\d{2})')
    def por_fecha(self, request, ymd=None):
        """GET /api/v1/calendario/fecha/2026-05-26/"""
        try:
            target = date.fromisoformat(ymd)
        except ValueError:
            return Response(
                {'detail': 'Formato esperado: YYYY-MM-DD'},
                status=status.HTTP_400_BAD_REQUEST,
            )
        obj = CalendarioLiturgico.objects.filter(fecha=target).first()
        if not obj:
            try:
                obj = LecturasProxyService().fetch_and_cache(target)
            except Exception:  # noqa: BLE001
                return Response(
                    {'detail': f'Lecturas no disponibles para {ymd}.'},
                    status=status.HTTP_404_NOT_FOUND,
                )
        return Response(self.get_serializer(obj).data)


# ============================================================
# Horarios de Misas
# ============================================================
class MisaHorarioViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = MisaHorario.objects.filter(activo=True)
    serializer_class = MisaHorarioSerializer


# ============================================================
# Videos de Misas (Facebook Live)
# ============================================================
class VideoMisaViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = VideoMisa.objects.all()
    serializer_class = VideoMisaSerializer

    @action(detail=False, methods=['get'], url_path='en-vivo')
    def en_vivo(self, request):
        qs = self.queryset.filter(estado=EstadoEmision.EN_VIVO)
        return Response(self.get_serializer(qs, many=True).data)

    @action(detail=False, methods=['get'], url_path='proximas')
    def proximas(self, request):
        qs = self.queryset.filter(
            estado=EstadoEmision.PROGRAMADA,
            fecha_evento__gte=timezone.now(),
        ).order_by('fecha_evento')[:10]
        return Response(self.get_serializer(qs, many=True).data)

    @action(detail=False, methods=['get'], url_path='destacadas')
    def destacadas(self, request):
        qs = self.queryset.filter(destacada=True).order_by('-fecha_evento')[:6]
        return Response(self.get_serializer(qs, many=True).data)


# ============================================================
# Intenciones de Oración — POST público + GET de muro público
# ============================================================
class IntencionOracionCreateView(generics.CreateAPIView):
    """POST /api/v1/intenciones/  — abierto sin login."""
    queryset = IntencionOracion.objects.all()
    serializer_class = IntencionOracionCreateSerializer

    def perform_create(self, serializer):
        serializer.save(
            ip_origen=_client_ip(self.request),
            user_agent=self.request.META.get('HTTP_USER_AGENT', '')[:255],
        )


class IntencionOracionMuroView(generics.ListAPIView):
    """GET /api/v1/intenciones/muro/  — solo intenciones aprobadas + públicas."""
    serializer_class = IntencionOracionPublicaSerializer

    def get_queryset(self):
        from .models import EstadoIntencion
        return IntencionOracion.objects.filter(
            es_publica=True,
            estado__in=[EstadoIntencion.EN_ORACION, EstadoIntencion.ATENDIDA],
        ).order_by('-creado_en')[:100]


# ============================================================
# Trigger manual del proxy (uso interno / cron job)
# ============================================================
class LecturasRefreshView(APIView):
    """
    POST /api/v1/calendario/refresh/?days=7
    Refresca la caché de lecturas para los próximos N días.
    En producción: protégelo con un token, por ahora abierto.
    """
    def post(self, request):
        days = int(request.query_params.get('days', 1))
        days = max(1, min(days, 14))
        result = LecturasProxyService().refresh_range(days_ahead=days)
        return Response(result)


# ============================================================
# Santo ViewSet
# ============================================================
class SantoViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Santo.objects.all()
    serializer_class = SantoSerializer

    @action(detail=False, methods=['get'], url_path='hoy')
    def hoy(self, request):
        today = timezone.localdate()
        obj = self.queryset.filter(fecha_celebracion__month=today.month, fecha_celebracion__day=today.day).first()
        if not obj:
            obj = self.queryset.first()
        if not obj:
            return Response({})
        return Response(self.get_serializer(obj).data)

    @action(detail=False, methods=['get'], url_path='mes')
    def mes(self, request):
        mes = request.query_params.get('mes')
        if not mes:
            mes = timezone.localdate().month
        else:
            mes = int(mes)
        qs = self.queryset.filter(fecha_celebracion__month=mes)
        return Response(self.get_serializer(qs, many=True).data)


# ============================================================
# Evento ViewSet
# ============================================================
class EventoViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Evento.objects.filter(activo=True)
    serializer_class = EventoSerializer

    @action(detail=False, methods=['get'], url_path='activos')
    def activos(self, request):
        qs = self.queryset.filter(fecha__gte=timezone.localdate())
        return Response(self.get_serializer(qs, many=True).data)

    @action(detail=False, methods=['get'], url_path=r'categoria/(?P<cat>[^/]+)')
    def por_categoria(self, request, cat=None):
        qs = self.queryset.filter(categoria=cat.lower())
        return Response(self.get_serializer(qs, many=True).data)

    @action(detail=False, methods=['get'], url_path='fecha')
    def por_fecha(self, request):
        f = request.query_params.get('fecha')
        if f:
            d = date.fromisoformat(f.split('T')[0])
            qs = self.queryset.filter(fecha=d)
        else:
            qs = self.queryset.none()
        return Response(self.get_serializer(qs, many=True).data)

    @action(detail=False, methods=['get'], url_path='rango')
    def rango(self, request):
        inicio = request.query_params.get('inicio')
        fin = request.query_params.get('fin')
        if inicio and fin:
            d_ini = date.fromisoformat(inicio.split('T')[0])
            d_fin = date.fromisoformat(fin.split('T')[0])
            qs = self.queryset.filter(fecha__range=[d_ini, d_fin])
        else:
            qs = self.queryset.none()
        return Response(self.get_serializer(qs, many=True).data)

    @action(detail=False, methods=['get'], url_path='buscar')
    def buscar(self, request):
        q = request.query_params.get('q', '')
        qs = self.queryset.filter(Q(titulo__icontains=q) | Q(descripcion__icontains=q))
        return Response(self.get_serializer(qs, many=True).data)

    @action(detail=True, methods=['post'], url_path='inscripcion')
    def inscribirse(self, request, pk=None):
        obj = self.get_object()
        if obj.maximo_participantes is None or obj.participantes_actuales < obj.maximo_participantes:
            obj.participantes_actuales += 1
            obj.save()
            return Response({'status': 'inscrito'})
        return Response({'detail': 'Evento lleno.'}, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=True, methods=['delete'], url_path=r'inscripcion/(?P<part_id>[^/]+)')
    def cancelar_inscripcion(self, request, pk=None, part_id=None):
        obj = self.get_object()
        if obj.participantes_actuales > 0:
            obj.participantes_actuales -= 1
            obj.save()
        return Response({'status': 'cancelado'})


# ============================================================
# ParroquiaInfo and OficinaInfo singleton views
# ============================================================
class ParroquiaInfoView(APIView):
    def get(self, request):
        obj = ParroquiaInfo.objects.first()
        if not obj:
            return Response({})
        return Response(ParroquiaInfoSerializer(obj).data)


class OficinaInfoView(APIView):
    def get(self, request):
        obj = OficinaInfo.objects.first()
        if not obj:
            return Response({})
        return Response(OficinaInfoSerializer(obj).data)


# ============================================================
# Oraciones ViewSet
# ============================================================
class OracionViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Oracion.objects.filter(activo=True)
    serializer_class = OracionSerializer
    lookup_field = 'slug'

    def get_serializer_class(self):
        if self.action == 'retrieve':
            return OracionDetalleSerializer
        return OracionSerializer

    @action(detail=False, methods=['get'], url_path='destacadas')
    def destacadas(self, request):
        """GET /api/v1/oraciones/destacadas/ -> lists featured active prayers"""
        qs = self.queryset.filter(destacada=True).order_by('orden', 'titulo')
        return Response(self.get_serializer(qs, many=True).data)

    @action(detail=False, methods=['get'], url_path=r'categoria/(?P<categoria>[^/]+)')
    def por_categoria(self, request, categoria=None):
        """GET /api/v1/oraciones/categoria/<categoria>/ -> lists active prayers in a category"""
        qs = self.queryset.filter(categoria=categoria.lower()).order_by('orden', 'titulo')
        return Response(self.get_serializer(qs, many=True).data)

