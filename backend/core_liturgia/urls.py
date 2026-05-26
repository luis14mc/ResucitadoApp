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

# ============================================================
# Aliases para rutas legacy del frontend Flutter
# ============================================================
# Los datasources antiguos (lecturas, horarios) usan paths heredados
# del backend Express. Hasta que se refactoricen, alias-amos:
#   /lecturas/hoy/      → /calendario/hoy/
#   /horarios-misa/     → /horarios/
# Así Flutter sigue funcionando sin cambios masivos.

# Vistas wrap-eadas para los aliases
_lecturas_hoy = views.CalendarioLiturgicoViewSet.as_view({'get': 'hoy'})
_horarios_list = views.MisaHorarioViewSet.as_view({'get': 'list'})

urlpatterns = [
    path('', include(router.urls)),

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

    # ---- Stubs temporales para features aún no migradas ----
    # Devuelven [] o {} sin error mientras se construyen los modelos.
    path('santos/hoy/', views.EmptyDictView.as_view(), name='santos-hoy-stub'),
    path('santos/', views.EmptyListView.as_view(), name='santos-stub'),
    path('santos/mes/', views.EmptyListView.as_view(), name='santos-mes-stub'),

    path('eventos/activos/', views.EmptyListView.as_view(), name='eventos-activos-stub'),
    path('eventos/', views.EmptyListView.as_view(), name='eventos-stub'),

    path('noticias/', views.EmptyListView.as_view(), name='noticias-stub'),
    path('oficina/info/', views.EmptyDictView.as_view(), name='oficina-info-stub'),
    path('parroquia/info/', views.EmptyDictView.as_view(), name='parroquia-info-stub'),
]
