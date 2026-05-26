"""
Management command:
    python manage.py fetch_lecturas               # solo hoy
    python manage.py fetch_lecturas --days 7      # próximos 7 días
    python manage.py fetch_lecturas --date 2026-06-01

Ideal para programar como cron job diario en Railway.
"""
from datetime import date
from django.core.management.base import BaseCommand, CommandError
from core_liturgia.services.lecturas_proxy import LecturasProxyService


class Command(BaseCommand):
    help = 'Refresca la caché local de lecturas litúrgicas (PostgreSQL).'

    def add_arguments(self, parser):
        parser.add_argument(
            '--days', type=int, default=1,
            help='Cantidad de días desde hoy a refrescar (por defecto 1).',
        )
        parser.add_argument(
            '--date', type=str, default=None,
            help='Fecha específica YYYY-MM-DD (sobreescribe --days).',
        )

    def handle(self, *args, **opts):
        service = LecturasProxyService()
        if opts['date']:
            try:
                target = date.fromisoformat(opts['date'])
            except ValueError as exc:
                raise CommandError(f'Fecha inválida: {exc}') from exc
            obj = service.fetch_and_cache(target)
            if obj:
                self.stdout.write(self.style.SUCCESS(f'OK · {obj}'))
            else:
                self.stdout.write(self.style.WARNING(f'Sin datos para {target}'))
            return

        result = service.refresh_range(days_ahead=opts['days'])
        self.stdout.write(self.style.SUCCESS(
            f"Refrescadas: {result['total']} · Fallidas: {len(result['fallidas'])}"
        ))
        for f in result['fallidas']:
            self.stdout.write(self.style.WARNING(f"  - {f['fecha']}: {f['error']}"))
