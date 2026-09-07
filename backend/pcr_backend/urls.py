"""
URL routing principal — pcr_backend.

- /admin/                Panel administrativo (Pastoral de Medios)
- /api/v1/               API REST consumida por Flutter
- /api/v1/health/        Healthcheck (Railway)
"""
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.http import JsonResponse
from django.db import connection
from django.utils import timezone
import logging

logger = logging.getLogger(__name__)


def health(_request):
    """Liveness/readiness endpoint that verifies the configured DB connection."""
    try:
        with connection.cursor() as cursor:
            cursor.execute('SELECT 1')
            cursor.fetchone()
    except Exception:  # noqa: BLE001
        logger.exception('Health check database failure')
        return JsonResponse(
            {'status': 'unhealthy', 'service': 'pcr_backend'},
            status=503,
        )
    return JsonResponse({
        'status': 'ok',
        'service': 'pcr_backend',
        'version': '2.0.0',
        'database': 'ok',
        'timestamp': timezone.now().isoformat(),
    })


urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/v1/health/', health, name='health'),
    path('api/v1/', include('core_liturgia.urls')),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

# Branding del admin
admin.site.site_header = 'Parroquia Cristo Resucitado · Admin'
admin.site.site_title = 'PCR Admin'
admin.site.index_title = 'Pastoral de Medios de Comunicación'
