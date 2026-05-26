import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Manager genérico para caché local con TTL (Time To Live)
class CacheManager {
  final SharedPreferences _prefs;
  static const String _timestampSuffix = '_timestamp';

  CacheManager(this._prefs);

  /// Guarda datos en caché con un timestamp
  Future<void> saveData(String key, Map<String, dynamic> data) async {
    final jsonString = json.encode(data);
    await _prefs.setString(key, jsonString);
    await _prefs.setInt(
      '$key$_timestampSuffix',
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Obtiene datos del caché si no han expirado
  Future<Map<String, dynamic>?> getData(
    String key, {
    Duration ttl = const Duration(hours: 24),
  }) async {
    final timestamp = _prefs.getInt('$key$_timestampSuffix');

    if (timestamp == null) {
      return null;
    }

    final cachedDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();

    // Verificar si el caché ha expirado
    if (now.difference(cachedDate) > ttl) {
      await clearData(key);
      return null;
    }

    final jsonString = _prefs.getString(key);
    if (jsonString == null) {
      return null;
    }

    try {
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      // Si hay error al decodificar, limpiar el caché
      await clearData(key);
      return null;
    }
  }

  /// Verifica si el caché es válido
  Future<bool> isCacheValid(
    String key, {
    Duration ttl = const Duration(hours: 24),
  }) async {
    final timestamp = _prefs.getInt('$key$_timestampSuffix');

    if (timestamp == null) {
      return false;
    }

    final cachedDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();

    return now.difference(cachedDate) <= ttl;
  }

  /// Limpia datos específicos del caché
  Future<void> clearData(String key) async {
    await _prefs.remove(key);
    await _prefs.remove('$key$_timestampSuffix');
  }

  /// Limpia todo el caché
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  /// Obtiene el timestamp de cuando se guardó el dato
  DateTime? getDataTimestamp(String key) {
    final timestamp = _prefs.getInt('$key$_timestampSuffix');
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }
}

/// Keys para los diferentes tipos de caché
class CacheKeys {
  static const String santoDelDia = 'santo_del_dia';
  static const String eventosActivos = 'eventos_activos';
  static const String lecturasDelDia = 'lecturas_del_dia';
}
