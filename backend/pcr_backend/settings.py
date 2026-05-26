"""
Django settings for pcr_backend project.
ResucitadoApp v2 — Parroquia Cristo Resucitado, Tegucigalpa, Honduras.

Listo para Railway (PostgreSQL via DATABASE_URL).
"""
from pathlib import Path
import os
import dj_database_url
from decouple import config, Csv

# ============================================================
# Paths
# ============================================================
BASE_DIR = Path(__file__).resolve().parent.parent

# ============================================================
# Seguridad
# ============================================================
SECRET_KEY = config(
    'SECRET_KEY',
    default='django-insecure-cambiame-en-produccion-CRISTORESUCITADO-TGU',
)
DEBUG = config('DEBUG', default=True, cast=bool)  # local-dev por defecto; en Railway pondrás DEBUG=False
ALLOWED_HOSTS = config(
    'ALLOWED_HOSTS',
    default='localhost,127.0.0.1,10.0.2.2',
    cast=Csv(),
)

# Railway inyecta su dominio público: lo añadimos automáticamente
RAILWAY_DOMAIN = os.environ.get('RAILWAY_PUBLIC_DOMAIN')
if RAILWAY_DOMAIN:
    ALLOWED_HOSTS.append(RAILWAY_DOMAIN)
    CSRF_TRUSTED_ORIGINS = [f'https://{RAILWAY_DOMAIN}']

# ============================================================
# Apps
# ============================================================
INSTALLED_APPS = [
    # Admin "bonito" para la Pastoral de Medios (opcional)
    'admin_interface',
    'colorfield',

    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    # Terceros
    'rest_framework',
    'corsheaders',

    # Locales
    'core_liturgia',
]

# ============================================================
# Middleware
# ============================================================
MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',           # CORS lo más arriba posible
    'django.middleware.security.SecurityMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',      # Servir estáticos en Railway
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'pcr_backend.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates'],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'pcr_backend.wsgi.application'

# ============================================================
# Base de Datos (PostgreSQL via dj-database-url)
# ============================================================
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

# ============================================================
# Validadores de contraseña
# ============================================================
AUTH_PASSWORD_VALIDATORS = [
    {'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator'},
    {'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator'},
    {'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator'},
    {'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator'},
]

# ============================================================
# Localización — Honduras
# ============================================================
LANGUAGE_CODE = 'es-hn'
TIME_ZONE = 'America/Tegucigalpa'
USE_I18N = True
USE_TZ = True

# ============================================================
# Archivos estáticos y media
# ============================================================
STATIC_URL = 'static/'
STATIC_ROOT = BASE_DIR / 'staticfiles'
STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'

MEDIA_URL = 'media/'
MEDIA_ROOT = BASE_DIR / 'media'

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# ============================================================
# Django REST Framework
# ============================================================
REST_FRAMEWORK = {
    'DEFAULT_RENDERER_CLASSES': [
        'rest_framework.renderers.JSONRenderer',
    ],
    'DEFAULT_PERMISSION_CLASSES': [
        # Lectura abierta para los fieles (sin login).
        'rest_framework.permissions.AllowAny',
    ],
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 25,
    'DATETIME_FORMAT': '%Y-%m-%dT%H:%M:%S%z',
}

# ============================================================
# CORS — Flutter ↔ Django
# ============================================================
CORS_ALLOW_ALL_ORIGINS = config('CORS_ALLOW_ALL_ORIGINS', default=DEBUG, cast=bool)
CORS_ALLOWED_ORIGINS = config(
    'CORS_ALLOWED_ORIGINS',
    default='http://localhost:3000,http://127.0.0.1:3000',
    cast=Csv(),
)
CORS_ALLOW_CREDENTIALS = True
CORS_ALLOW_METHODS = [
    'DELETE', 'GET', 'OPTIONS', 'PATCH', 'POST', 'PUT',
]
CORS_ALLOW_HEADERS = [
    'accept', 'accept-encoding', 'authorization', 'content-type',
    'dnt', 'origin', 'user-agent', 'x-csrftoken', 'x-requested-with',
]

# ============================================================
# Branding (para admin-interface)
# ============================================================
PCR_COLOR_PRIMARY = '#9E2E21'   # Marrón Litúrgico
PCR_COLOR_SECONDARY = '#E3A822' # Dorado

# ============================================================
# Proxy de Lecturas Litúrgicas
# ============================================================
LECTURAS_SOURCE_URL = config(
    'LECTURAS_SOURCE_URL',
    default='https://www.ciudadredonda.org/calendario-lecturas-diarias',
)
LECTURAS_USER_AGENT = config(
    'LECTURAS_USER_AGENT',
    default='ResucitadoApp/2.0 (+contacto@cristoresucitado.hn)',
)
LECTURAS_REQUEST_TIMEOUT = config('LECTURAS_REQUEST_TIMEOUT', default=15, cast=int)

# ============================================================
# Seguridad
# ============================================================
# Local: nunca forzar HTTPS (Django runserver solo habla HTTP plano,
# y si esto se activa por error, Dio recibe 301→https y revienta).
SECURE_SSL_REDIRECT = False
SESSION_COOKIE_SECURE = False
CSRF_COOKIE_SECURE = False
SECURE_HSTS_SECONDS = 0

# Producción (Railway): el bloque sólo se activa si explicitamente
# desactivas DEBUG via variable de entorno (DEBUG=False en Railway).
if not DEBUG:
    SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
    SECURE_SSL_REDIRECT = True
    SESSION_COOKIE_SECURE = True
    CSRF_COOKIE_SECURE = True
    SECURE_HSTS_SECONDS = 31536000
    SECURE_HSTS_INCLUDE_SUBDOMAINS = True
    SECURE_HSTS_PRELOAD = True
