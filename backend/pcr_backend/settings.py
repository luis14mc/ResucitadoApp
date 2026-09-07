"""
Django settings for pcr_backend project.
ResucitadoApp v2 — Parroquia Cristo Resucitado, Tegucigalpa, Honduras.

Listo para Railway (PostgreSQL via DATABASE_URL).
"""
from pathlib import Path
import os
import dj_database_url
from decouple import config, Csv
from django.core.exceptions import ImproperlyConfigured

# ============================================================
# Paths
# ============================================================
BASE_DIR = Path(__file__).resolve().parent.parent

# ============================================================
# Seguridad
# ============================================================
APP_ENV = config('APP_ENV', default='development').strip().lower()
IS_PRODUCTION = APP_ENV in {'production', 'prod'} or bool(os.environ.get('RAILWAY_ENVIRONMENT_NAME'))

# Development remains convenient locally, while hosted environments fail fast
# when a required secret/configuration value is missing.
DEBUG = config('DEBUG', default=not IS_PRODUCTION, cast=bool)
if IS_PRODUCTION and DEBUG:
    raise ImproperlyConfigured('DEBUG must be False in production.')
SECRET_KEY = config('SECRET_KEY', default='')
if IS_PRODUCTION and (
    not SECRET_KEY
    or SECRET_KEY.startswith('django-insecure')
    or len(SECRET_KEY) < 50
    or len(set(SECRET_KEY)) < 5
):
    raise ImproperlyConfigured('SECRET_KEY must be set to a strong value in production.')
if not SECRET_KEY:
    SECRET_KEY = 'django-insecure-local-only-change-me'

ALLOWED_HOSTS = [host.strip() for host in config(
    'ALLOWED_HOSTS',
    default='localhost,127.0.0.1,10.0.2.2' if not IS_PRODUCTION else '',
    cast=Csv(),
) if host.strip()]
# Railway inyecta su dominio público: lo añadimos automáticamente
RAILWAY_DOMAIN = os.environ.get('RAILWAY_PUBLIC_DOMAIN')
if RAILWAY_DOMAIN:
    if RAILWAY_DOMAIN not in ALLOWED_HOSTS:
        ALLOWED_HOSTS.append(RAILWAY_DOMAIN)
if IS_PRODUCTION and not ALLOWED_HOSTS:
    raise ImproperlyConfigured('ALLOWED_HOSTS must contain the public API hostname in production.')

CSRF_TRUSTED_ORIGINS = [origin.strip() for origin in config(
    'CSRF_TRUSTED_ORIGINS',
    default='',
    cast=Csv(),
) if origin.strip()]
if RAILWAY_DOMAIN and f'https://{RAILWAY_DOMAIN}' not in CSRF_TRUSTED_ORIGINS:
    CSRF_TRUSTED_ORIGINS.append(f'https://{RAILWAY_DOMAIN}')

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
# Base de Datos (PostgreSQL via DATABASE_URL)
# ============================================================
DATABASE_URL = os.environ.get('DATABASE_URL', '').strip()
if DATABASE_URL:
    parsed_database = dj_database_url.parse(
        DATABASE_URL,
        conn_max_age=config('DB_CONN_MAX_AGE', default=600, cast=int),
        ssl_require=IS_PRODUCTION,
    )
    if IS_PRODUCTION and parsed_database.get('ENGINE') == 'django.db.backends.sqlite3':
        raise ImproperlyConfigured('Production DATABASE_URL must point to PostgreSQL, not SQLite.')
    DATABASES = {
        'default': parsed_database,
    }
elif IS_PRODUCTION:
    raise ImproperlyConfigured('DATABASE_URL is required in production; SQLite is not supported there.')
else:
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

MEDIA_URL = config('MEDIA_URL', default='/media/')
MEDIA_ROOT = Path(config('MEDIA_ROOT', default=str(BASE_DIR / 'media')))
if IS_PRODUCTION and not os.environ.get('MEDIA_ROOT'):
    raise ImproperlyConfigured(
        'MEDIA_ROOT must point to a persistent volume/object-storage mount in production.'
    )

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# Throttles must share state across Gunicorn workers in production.  Django's
# database cache avoids introducing a second infrastructure dependency.
if IS_PRODUCTION:
    CACHES = {
        'default': {
            'BACKEND': 'django.core.cache.backends.db.DatabaseCache',
            'LOCATION': config('CACHE_TABLE', default='django_cache'),
        }
    }
else:
    CACHES = {
        'default': {
            'BACKEND': 'django.core.cache.backends.locmem.LocMemCache',
            'LOCATION': 'resucitadoapp-local',
        }
    }

# ============================================================
# Django REST Framework
# ============================================================
REST_FRAMEWORK = {
    'DEFAULT_RENDERER_CLASSES': [
        'rest_framework.renderers.JSONRenderer',
    ],
    'DEFAULT_PERMISSION_CLASSES': [
        # Read-only endpoints are public; write endpoints override this.
        'rest_framework.permissions.AllowAny',
    ],
    'DEFAULT_THROTTLE_CLASSES': [
        'rest_framework.throttling.AnonRateThrottle',
        'rest_framework.throttling.ScopedRateThrottle',
    ],
    'DEFAULT_THROTTLE_RATES': {
        'anon': config('API_ANON_RATE', default='120/minute'),
        'intenciones': config('INTENCIONES_RATE', default='5/hour'),
        'inscripciones': config('INSCRIPCIONES_RATE', default='10/hour'),
        'refresh': config('LECTURAS_REFRESH_RATE', default='10/hour'),
    },
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 25,
    'DATETIME_FORMAT': '%Y-%m-%dT%H:%M:%S%z',
}

# ============================================================
# CORS — Flutter ↔ Django
# ============================================================
CORS_ALLOW_ALL_ORIGINS = config('CORS_ALLOW_ALL_ORIGINS', default=DEBUG, cast=bool)
if IS_PRODUCTION and CORS_ALLOW_ALL_ORIGINS:
    raise ImproperlyConfigured('CORS_ALLOW_ALL_ORIGINS cannot be enabled in production.')
CORS_ALLOWED_ORIGINS = config(
    'CORS_ALLOWED_ORIGINS',
    default='http://localhost:3000,http://127.0.0.1:3000',
    cast=Csv(),
)
CORS_ALLOW_CREDENTIALS = config('CORS_ALLOW_CREDENTIALS', default=False, cast=bool)
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
TRUST_PROXY_HEADERS = config('TRUST_PROXY_HEADERS', default=IS_PRODUCTION, cast=bool)

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
if IS_PRODUCTION or not DEBUG:
    SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
    SECURE_SSL_REDIRECT = True
    SESSION_COOKIE_SECURE = True
    CSRF_COOKIE_SECURE = True
    SECURE_HSTS_SECONDS = 31536000
    SECURE_HSTS_INCLUDE_SUBDOMAINS = True
    SECURE_HSTS_PRELOAD = True

# Internal API actions (for example the scheduled reading refresh) must use
# an explicit service token or an authenticated staff user.
LECTURAS_REFRESH_TOKEN = config('LECTURAS_REFRESH_TOKEN', default='')
if IS_PRODUCTION and not LECTURAS_REFRESH_TOKEN:
    raise ImproperlyConfigured('LECTURAS_REFRESH_TOKEN is required in production.')

# Keep operational logs useful without leaking request bodies or credentials.
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'default': {
            'format': '{levelname} {asctime} {name} {message}',
            'style': '{',
        },
    },
    'handlers': {
        'console': {'class': 'logging.StreamHandler', 'formatter': 'default'},
    },
    'loggers': {
        'django': {'handlers': ['console'], 'level': 'INFO'},
        'core_liturgia': {'handlers': ['console'], 'level': 'INFO', 'propagate': False},
    },
}
