import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor para logging mejorado con emojis y formato claro
///
/// Solo activo en modo debug
class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────────────────');
      debugPrint('│ 🌐 REQUEST');
      debugPrint('├─────────────────────────────────────────────────');
      debugPrint('│ Method: ${options.method}');
      debugPrint('│ URL: ${options.uri}');
      if (options.queryParameters.isNotEmpty) {
        debugPrint('│ Query Params: ${options.queryParameters}');
      }
      if (options.headers.isNotEmpty) {
        debugPrint('│ Headers: ${options.headers}');
      }
      if (options.data != null) {
        debugPrint('│ Body: ${options.data}');
      }
      debugPrint('└─────────────────────────────────────────────────');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────────────────');
      debugPrint('│ ✅ RESPONSE');
      debugPrint('├─────────────────────────────────────────────────');
      debugPrint('│ Status: ${response.statusCode}');
      debugPrint('│ URL: ${response.requestOptions.uri}');
      debugPrint('│ Data: ${response.data}');
      debugPrint('└─────────────────────────────────────────────────');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────────────────');
      debugPrint('│ ❌ ERROR');
      debugPrint('├─────────────────────────────────────────────────');
      debugPrint('│ Type: ${err.type}');
      debugPrint('│ URL: ${err.requestOptions.uri}');
      debugPrint('│ Message: ${err.message}');
      debugPrint('│ Status Code: ${err.response?.statusCode}');
      if (err.response?.data != null) {
        debugPrint('│ Error Data: ${err.response?.data}');
      }
      debugPrint('└─────────────────────────────────────────────────');
    }
    handler.next(err);
  }
}
