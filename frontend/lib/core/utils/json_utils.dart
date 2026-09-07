/// Helpers pequeños para consumir respuestas REST con campos opcionales o
/// nombres camelCase/snake_case sin hacer casts inseguros en la UI.
class JsonUtils {
  const JsonUtils._();

  static dynamic value(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      if (json.containsKey(key) && json[key] != null) return json[key];
    }
    return null;
  }

  static String string(
    Map<String, dynamic> json,
    List<String> keys, {
    String fallback = '',
  }) =>
      value(json, keys)?.toString() ?? fallback;

  static int integer(
    Map<String, dynamic> json,
    List<String> keys, {
    int fallback = 0,
  }) {
    final raw = value(json, keys);
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    return int.tryParse(raw?.toString() ?? '') ?? fallback;
  }

  static bool boolean(
    Map<String, dynamic> json,
    List<String> keys, {
    bool fallback = false,
  }) {
    final raw = value(json, keys);
    if (raw is bool) return raw;
    if (raw is num) return raw != 0;
    final normalized = raw?.toString().toLowerCase().trim();
    if (normalized == 'true' || normalized == '1' || normalized == 'si') {
      return true;
    }
    if (normalized == 'false' || normalized == '0' || normalized == 'no') {
      return false;
    }
    return fallback;
  }

  static DateTime? date(Map<String, dynamic> json, List<String> keys) {
    final raw = value(json, keys);
    return raw == null ? null : DateTime.tryParse(raw.toString());
  }

  static List<String> stringList(dynamic raw) {
    if (raw is List) {
      return raw
          .where((item) => item != null)
          .map((item) => item.toString())
          .toList();
    }
    return const [];
  }
}
