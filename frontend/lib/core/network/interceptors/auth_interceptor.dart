import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Interceptor para añadir token de autenticación a las peticiones
///
/// Añade automáticamente el token JWT almacenado en SharedPreferences
/// a las cabeceras de todas las peticiones
class AuthInterceptor extends Interceptor {
  static const String _tokenKey = 'auth_token';

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Obtener token almacenado
    final token = await _getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Si el error es 401 (No autorizado), limpiar token
    if (err.response?.statusCode == 401) {
      await _clearToken();
    }

    handler.next(err);
  }

  /// Obtiene el token almacenado
  Future<String?> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      return null;
    }
  }

  /// Limpia el token almacenado
  Future<void> _clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
    } catch (e) {
      // Ignorar error
    }
  }

  /// Guarda el token (método estático para usar desde otros lugares)
  static Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    } catch (e) {
      // Ignorar error
    }
  }

  /// Verifica si hay un token guardado
  static Future<bool> hasToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
