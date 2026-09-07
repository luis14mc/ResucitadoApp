# Despliegue del backend

El backend debe ejecutarse con `APP_ENV=production` y PostgreSQL. No se debe
usar SQLite en Railway ni en otro entorno hospedado.

Variables mínimas:

```text
APP_ENV=production
DEBUG=False
SECRET_KEY=<secreto aleatorio largo>
DATABASE_URL=postgresql://...
ALLOWED_HOSTS=<dominio-api>
CORS_ALLOWED_ORIGINS=https://<dominio-web>
CSRF_TRUSTED_ORIGINS=https://<dominio-web>,https://<dominio-api>
LECTURAS_REFRESH_TOKEN=<secreto exclusivo para el job de lecturas>
MEDIA_ROOT=/data/media
```

`MEDIA_ROOT` debe ser un volumen persistente (o un montaje respaldado por
object storage). Si no existe, el proceso falla al arrancar para evitar perder
las imágenes cargadas desde el admin.

El arranque crea la tabla `django_cache`, usada por los throttles para
compartir límites entre los workers de Gunicorn.

El health check es `GET /api/v1/health/`; responde `503` si la aplicación no
puede conectarse a la base de datos. El refresh de lecturas es una operación
interna: usa `X-Internal-Token: <LECTURAS_REFRESH_TOKEN>` o
`Authorization: Bearer <LECTURAS_REFRESH_TOKEN>`.

Antes de promover un release:

```powershell
python manage.py check --deploy
python manage.py migrate --check
python manage.py test core_liturgia
python manage.py collectstatic --noinput
```

Las inscripciones de eventos requieren el encabezado opcional
`Idempotency-Key`. El API devuelve `inscripcion_id`, que debe conservar el
cliente para cancelar la inscripción sin alterar el contador de otra persona.
