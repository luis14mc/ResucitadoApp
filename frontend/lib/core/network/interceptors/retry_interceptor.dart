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
    var currentError = err;
    var retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    while (_shouldRetry(currentError) && retryCount < maxRetries) {
      final request = currentError.requestOptions;
      retryCount++;
      request.extra['retryCount'] = retryCount;

      if (kDebugMode) {
        debugPrint('🔄 Reintentando petición... ($retryCount/$maxRetries)');
      }

      await Future.delayed(retryDelay * retryCount);

      try {
        final dio = Dio(BaseOptions(
          baseUrl: request.baseUrl,
          connectTimeout: request.connectTimeout,
          receiveTimeout: request.receiveTimeout,
          sendTimeout: request.sendTimeout,
          headers: request.headers,
        ));
        final response = await dio.request(
          request.path,
          data: request.data,
          queryParameters: request.queryParameters,
          options: Options(
            method: request.method,
            contentType: request.contentType,
            responseType: request.responseType,
          ),
        );

        return handler.resolve(response);
      } on DioException catch (e) {
        currentError = e;
      }
    }

    return super.onError(currentError, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
  }
}
