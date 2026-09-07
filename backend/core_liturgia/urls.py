"""
core_liturgia.urls
Mapeo de la API REST consumida por Flutter.

Prefijo global: /api/v1/  (definido en pcr_backend/urls.py)
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register('calendario', views.CalendarioLiturgicoViewSet, basename='calendario')
router.register('horarios', views.MisaHorarioViewSet, basename='horarios')
router.register('emisiones', views.VideoMisaViewSet, basename='emisiones')
router.register('santos', views.SantoViewSet, basename='santos')
router.register('eventos', views.EventoViewSet, basename='eventos')
router.register('oraciones', views.OracionViewSet, basename='oraciones')

# ============================================================
# Aliases para rutas legacy del frontend Flutter
# ============================================================
# Los datasources antiguos (lecturas, horarios) usan paths heredados
# del backend Express. Hasta que se refactoricen, alias-amos:
#   /lecturas/hoy/      → /calendario/hoy/
#   /horarios-misa/     → /horarios/
#   Así Flutter sigue funcionando sin cambios masivos.

# Vistas wrap-eadas para los aliases
_lecturas_hoy = views.CalendarioLiturgicoViewSet.as_view({'get': 'hoy'})
_horarios_list = views.MisaHorarioViewSet.as_view({'get': 'list'})

urlpatterns = [
    # ---- Intenciones de oración ----
    path('intenciones/',
         views.IntencionOracionCreateView.as_view(),
         name='intenciones-create'),
    path('intenciones/muro/',
         views.IntencionOracionMuroView.as_view(),
         name='intenciones-muro'),

    # ---- Trigger manual del proxy de lecturas ----
    path('calendario/refresh/',
         views.LecturasRefreshView.as_view(),
         name='lecturas-refresh'),

    # ---- Aliases legacy (compat con datasources v1) ----
    path('lecturas/hoy/', _lecturas_hoy, name='lecturas-hoy-alias'),
    path('horarios-misa/', _horarios_list, name='horarios-misa-alias'),

    # ---- Noticias y stubs ----
    path('noticias/', views.EmptyListView.as_view(), name='noticias-stub'),
    
    # ---- Información parroquial y de oficina ----
    path('parroquia/info/', views.ParroquiaInfoView.as_view(), name='parroquia-info'),
    path('oficina/info/', views.OficinaInfoView.as_view(), name='oficina-info'),

    # Keep explicit paths before the router: otherwise /calendario/refresh/
    # can be interpreted as the router's /calendario/<pk>/ detail route.
    path('', include(router.urls)),
]
