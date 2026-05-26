"""
core_liturgia.services.lecturas_proxy
---------------------------------------------
Proxy automático para obtener las lecturas litúrgicas diarias desde
fuentes públicas en internet y persistirlas en PostgreSQL como caché.

Diseño:
- `LecturasProxyService` orquesta el flujo: fetch -> parse -> upsert.
- `BaseSource` es el contrato que cualquier fuente debe cumplir.
- `CiudadRedondaSource` es la primera implementación. Se pueden añadir más
  (USCCB, ACI Prensa, evangeliodeldia.org, etc.) sin tocar el servicio.

Política de sobrescritura:
- Si la fila ya existe Y fue marcada `editado_manualmente=True`, NO se
  toca: respetamos a la Pastoral.
- En cualquier otro caso, se actualiza con lo importado.

Robustez:
- Timeout configurable.
- User-Agent identificable (cortesía hacia las fuentes).
- Logs claros: imprime un resumen por fecha.
- No revienta el request del usuario: si falla, retorna None y registra.
"""
from __future__ import annotations

import logging
import re
from dataclasses import dataclass, field, asdict
from datetime import date, timedelta
from typing import Optional, List

import requests
from bs4 import BeautifulSoup
from django.conf import settings
from django.utils import timezone

from ..models import (
    CalendarioLiturgico,
    ColorLiturgico,
    TipoCelebracion,
)

logger = logging.getLogger(__name__)


# ============================================================
# DTO de lecturas (lo que devuelve un Source)
# ============================================================
@dataclass
class LecturasDelDia:
    fecha: date
    titulo: str = ''
    tipo_celebracion: str = TipoCelebracion.FERIA
    color_liturgico: str = ColorLiturgico.VERDE

    primera_lectura_cita: str = ''
    primera_lectura_texto: str = ''

    salmo_cita: str = ''
    salmo_respuesta: str = ''
    salmo_texto: str = ''

    segunda_lectura_cita: str = ''
    segunda_lectura_texto: str = ''

    aclamacion_evangelio: str = ''
    evangelio_cita: str = ''
    evangelio_texto: str = ''

    fuente: str = ''

    def to_model_kwargs(self) -> dict:
        d = asdict(self)
        d.pop('fecha', None)
        return d


# ============================================================
# Contrato base
# ============================================================
class BaseSource:
    name: str = 'base'
    base_url: str = ''

    def __init__(self, session: Optional[requests.Session] = None):
        self.session = session or requests.Session()
        self.session.headers.update({
            'User-Agent': getattr(
                settings, 'LECTURAS_USER_AGENT',
                'ResucitadoApp/2.0',
            ),
            'Accept-Language': 'es-HN,es;q=0.9',
        })
        self.timeout = getattr(settings, 'LECTURAS_REQUEST_TIMEOUT', 15)

    def fetch(self, target: date) -> Optional[LecturasDelDia]:
        raise NotImplementedError


# ============================================================
# Fuente: Ciudad Redonda (Franciscanos de España, en español)
# ============================================================
class CiudadRedondaSource(BaseSource):
    name = 'ciudadredonda'
    # La URL real es algo como:
    #   https://www.ciudadredonda.org/calendario-lecturas-diarias/YYYY-MM-DD
    # Se mantiene parametrizable vía settings.LECTURAS_SOURCE_URL.
    base_url = 'https://www.ciudadredonda.org/calendario-lecturas-diarias'

    def fetch(self, target: date) -> Optional[LecturasDelDia]:
        url = f'{self.base_url}/{target.isoformat()}'
        try:
            resp = self.session.get(url, timeout=self.timeout)
            resp.raise_for_status()
        except requests.RequestException as exc:
            logger.warning('Ciudad Redonda fetch error %s: %s', target, exc)
            return None

        soup = BeautifulSoup(resp.text, 'lxml')
        data = LecturasDelDia(fecha=target, fuente=url)

        # NOTA para la Pastoral / mantenedor:
        # El parser asume estructura típica de la página. Si Ciudad Redonda
        # cambia su HTML, ajustar los selectores aquí. Se diseñó tolerante:
        # si un bloque no está, simplemente queda en cadena vacía.
        try:
            titulo = soup.select_one('h1, h2.titulo, .titulo-celebracion')
            if titulo:
                data.titulo = titulo.get_text(strip=True)

            # Heurística de color: buscamos clases o textos típicos
            color_hint = soup.select_one('.color-liturgico, .color')
            if color_hint:
                data.color_liturgico = self._normalize_color(
                    color_hint.get_text(strip=True)
                )

            # Bloques de lectura — clases genéricas que muchos sitios usan
            for block in soup.select('.lectura, .reading, .seccion-lectura'):
                self._parse_block(block, data)

        except Exception as exc:  # noqa: BLE001
            logger.exception('Parsing error en %s: %s', url, exc)

        return data

    # ---- helpers ----
    @staticmethod
    def _normalize_color(raw: str) -> str:
        raw = (raw or '').strip().lower()
        mapping = {
            'blanco': ColorLiturgico.BLANCO,
            'rojo': ColorLiturgico.ROJO,
            'verde': ColorLiturgico.VERDE,
            'morado': ColorLiturgico.MORADO,
            'violeta': ColorLiturgico.MORADO,
            'rosa': ColorLiturgico.ROSA,
            'dorado': ColorLiturgico.DORADO,
            'oro': ColorLiturgico.DORADO,
            'negro': ColorLiturgico.NEGRO,
        }
        for key, val in mapping.items():
            if key in raw:
                return val
        return ColorLiturgico.VERDE

    @staticmethod
    def _parse_block(block, data: LecturasDelDia) -> None:
        """Detecta de qué tipo de lectura se trata por el header del bloque."""
        header = block.find(['h2', 'h3', 'h4'])
        body = block.get_text('\n', strip=True)
        cita_match = re.search(r'\(([^)]+)\)', body[:200])
        cita = cita_match.group(1).strip() if cita_match else ''

        if not header:
            return
        htxt = header.get_text(strip=True).lower()

        if 'primera lectura' in htxt or 'lectura del libro' in htxt:
            data.primera_lectura_cita = cita
            data.primera_lectura_texto = body
        elif 'salmo' in htxt:
            data.salmo_cita = cita
            data.salmo_texto = body
            resp_match = re.search(r'r\.?\s*[:\-–]\s*(.+)', body, flags=re.I)
            if resp_match:
                data.salmo_respuesta = resp_match.group(1).strip().split('\n')[0]
        elif 'segunda lectura' in htxt:
            data.segunda_lectura_cita = cita
            data.segunda_lectura_texto = body
        elif 'evangelio' in htxt:
            data.evangelio_cita = cita
            data.evangelio_texto = body
        elif 'aclamación' in htxt or 'aleluya' in htxt:
            data.aclamacion_evangelio = body


# ============================================================
# Servicio principal
# ============================================================
class LecturasProxyService:
    """
    Orquestador. Por defecto consulta CiudadRedondaSource.
    Para añadir más fuentes, instánciar con `sources=[A(), B()]` y
    el servicio intentará en orden hasta obtener una lectura válida.
    """

    def __init__(self, sources: Optional[List[BaseSource]] = None):
        self.sources = sources or [CiudadRedondaSource()]

    # ---- API pública ----
    def fetch_and_cache(self, target: date) -> Optional[CalendarioLiturgico]:
        """Trae lecturas para `target` y las upserta en la base."""
        existing = CalendarioLiturgico.objects.filter(fecha=target).first()
        if existing and existing.editado_manualmente:
            logger.info('Saltando %s (editado_manualmente).', target)
            return existing

        lecturas = self._fetch_first_available(target)
        if not lecturas:
            return existing  # devolvemos lo que haya, aunque sea None

        defaults = lecturas.to_model_kwargs()
        defaults['importado_en'] = timezone.now()

        obj, _ = CalendarioLiturgico.objects.update_or_create(
            fecha=target,
            defaults=defaults,
        )
        logger.info('Lecturas importadas para %s desde %s.',
                    target, lecturas.fuente)
        return obj

    def refresh_range(self, days_ahead: int = 7, start: Optional[date] = None) -> dict:
        """Refresca las lecturas para un rango (útil para cron diario)."""
        start = start or timezone.localdate()
        ok, fail = [], []
        for offset in range(days_ahead):
            d = start + timedelta(days=offset)
            try:
                self.fetch_and_cache(d)
                ok.append(d.isoformat())
            except Exception as exc:  # noqa: BLE001
                logger.exception('refresh_range error %s: %s', d, exc)
                fail.append({'fecha': d.isoformat(), 'error': str(exc)})
        return {'refrescadas': ok, 'fallidas': fail, 'total': len(ok)}

    # ---- internals ----
    def _fetch_first_available(self, target: date) -> Optional[LecturasDelDia]:
        for source in self.sources:
            try:
                lecturas = source.fetch(target)
            except Exception as exc:  # noqa: BLE001
                logger.exception('Source %s falló: %s', source.name, exc)
                continue
            if lecturas and (lecturas.evangelio_texto or lecturas.primera_lectura_texto):
                return lecturas
        return None
