import 'package:dio/dio.dart';
import 'package:orderly/core/di/service_locator.dart';

/// Logs all outgoing requests and incoming responses/errors.
/// Named [LoggingInterceptor] to avoid shadowing Dio's built-in [LogInterceptor].
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    talker.debug(
      '🚀 [${options.method}] ${options.uri}\n'
      '📤 Headers: ${options.headers}\n'
      '📦 Body: ${options.data}',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    talker.debug(
      '✅ [${response.statusCode}] ${response.requestOptions.uri}\n'
      '📬 Body: ${response.data}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    talker.error(
      '❌ [${err.response?.statusCode}] ${err.requestOptions.uri}\n'
      '💬 Message: ${err.message}\n'
      '🔥 Response: ${err.response?.data}',
    );
    handler.next(err);
  }
}