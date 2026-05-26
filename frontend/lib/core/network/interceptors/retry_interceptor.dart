import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor para reintentos automáticos en caso de errores de red
///
/// Reintenta automáticamente las peticiones que fallen por timeout o conexión
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && err.requestOptions.extra['retryCount'] == null) {
      err.requestOptions.extra['retryCount'] = 0;
    }

    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    if (_shouldRetry(err) && retryCount < maxRetries) {
      err.requestOptions.extra['retryCount'] = retryCount + 1;

      if (kDebugMode) {
        debugPrint(
            '🔄 Reintentando petición... (${retryCount + 1}/$maxRetries)');
      }

      await Future.delayed(retryDelay * (retryCount + 1));

      try {
        final dio = Dio();
        // Copy base options from the original request
        dio.options.baseUrl = err.requestOptions.baseUrl;
        dio.options.connectTimeout = err.requestOptions.connectTimeout;
        dio.options.receiveTimeout = err.requestOptions.receiveTimeout;
        dio.options.sendTimeout = err.requestOptions.sendTimeout;

        final response = await dio.request(
          err.requestOptions.path,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
          options: Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
            contentType: err.requestOptions.contentType,
            responseType: err.requestOptions.responseType,
          ),
        );

        return handler.resolve(response);
      } on DioException catch (e) {
        return super.onError(e, handler);
      }
    }

    return super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
  }
}
