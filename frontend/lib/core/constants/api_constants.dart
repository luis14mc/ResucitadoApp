// ignore_for_file: constant_identifier_names
//
// ============================================================
// ResucitadoApp v2 · API Constants
// Parroquia Cristo Resucitado · Tegucigalpa, Honduras
// ------------------------------------------------------------
// Backend: Django + DRF (pcr_backend)  →  /api/v1/
//
// Convención Django: TODOS los paths terminan con `/`.
// Si no se incluye el `/` final, Django emite 301 y Dio falla en
// algunos escenarios (especialmente al encadenar con HTTPS).
//
// Selección automática de host:
//   · Android emulador  → 10.0.2.2:8000
//   · iOS sim / Web / Win / macOS → localhost:8000
//   · Override prod  →  --dart-define=API_BASE_URL=https://...
// ============================================================
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConstants {
  ApiConstants._();

  // ----------------------------------------------------------
  //  Base URL — resolución por plataforma
  // ----------------------------------------------------------
  static const String _envBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );
  static const int _devPort = 8000;
  static const String _apiPrefix = '/api/v1';

  static String get baseUrl {
    if (_envBaseUrl.isNotEmpty) return _envBaseUrl;
    if (kIsWeb) return 'http://localhost:$_devPort$_apiPrefix';
    if (Platform.isAndroid) return 'http://10.0.2.2:$_devPort$_apiPrefix';
    return 'http://localhost:$_devPort$_apiPrefix';
  }

  static String get webBaseUrl => baseUrl;

  // ----------------------------------------------------------
  //  Endpoints — TODOS con trailing slash (Django convention)
  // ----------------------------------------------------------

  // -- Calendario / Lecturas --
  static const String calendario = '/calendario/';
  static const String lecturasHoy = '/calendario/hoy/';
  static String lecturasPorFecha(String yyyymmdd) =>
      '/calendario/fecha/$yyyymmdd/';
  static const String lecturasRefresh = '/calendario/refresh/';

  // Aliases legacy (Django ya los expone para no romper datasources)
  static const String lecturasLegacy = '/lecturas/';
  static const String lecturasHoyLegacy = '/lecturas/hoy/';

  // -- Horarios de misas --
  static const String horarios = '/horarios/';
  static const String horariosMisa = '/horarios-misa/'; // alias legacy

  // -- Emisiones (Facebook Live) --
  static const String emisiones = '/emisiones/';
  static const String emisionesEnVivo = '/emisiones/en-vivo/';
  static const String emisionesProximas = '/emisiones/proximas/';
  static const String emisionesDestacadas = '/emisiones/destacadas/';

  // -- Intenciones de oración --
  static const String intenciones = '/intenciones/';
  static const String intencionesMuro = '/intenciones/muro/';

  // -- Santos (stub mientras se migra de Express a Django) --
  static const String santos = '/santos/';
  static const String santoDelDia = '/santos/hoy/';
  static const String santosPorMes = '/santos/mes/';

  // -- Eventos (stub mientras se migra) --
  static const String eventos = '/eventos/';
  static const String eventosActivos = '/eventos/activos/';
  static const String eventosPorCategoria = '/eventos/categoria/';

  // -- Noticias / Parroquia / Oficina --
  static const String noticias = '/noticias/';
  static const String parroquia = '/parroquia/';
  static const String parroquiaInfo = '/parroquia/info/';
  static const String oficina = '/oficina/';
  static const String oficinaInfo = '/oficina/info/';

  // -- Healthcheck --
  static const String health = '/health/';

  // ----------------------------------------------------------
  //  Headers
  // ----------------------------------------------------------
  static const String contentType = 'application/json';
  static const String accept = 'application/json';

  // ----------------------------------------------------------
  //  Timeouts (subidos respecto a v1: red 4G en Honduras puede
  //  tener latencias de 1-2s; 3000ms bajaba el ratio de éxito)
  // ----------------------------------------------------------
  static const int connectTimeout = 10000;
  static const int receiveTimeout = 15000;
  static const int sendTimeout = 10000;

  // ----------------------------------------------------------
  //  Caché local
  // ----------------------------------------------------------
  static const String cacheDir = 'api_cache';
  static const int cacheDuration = 3600;

  static const String apiVersion = 'v1';
}
