import 'package:dio/dio.dart';
import 'package:orderly/core/di/service_locator.dart';
class ErrorInterceptor extends QueuedInterceptor {
  ErrorInterceptor(this._dio);
  final Dio _dio;
  static const _retryHeader = 'x-retry-after-refresh';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    _logError(err);

    // ── 401 handling with one retry ───────────────────────────────────────
    final is401 = err.response?.statusCode == 401;
    final alreadyRetried = err.requestOptions.headers[_retryHeader] == true;

    if (is401 && !alreadyRetried) {
      talker.warning('🔄 401 received — attempting token refresh');

      final refreshed = await _tryRefreshToken();

      if (refreshed) {
        talker.info('✅ Token refreshed — retrying original request');
        return handler.resolve(await _retry(err.requestOptions));
      } else {
        talker.warning('🚪 Refresh failed — clearing session');
        await _clearSessionAndRedirect();
        return handler.next(err);
      }
    }

    handler.next(err);
  }

  // ── Private helpers ──────────────────────────────────────────────────────

  Future<bool> _tryRefreshToken() async {
    try {
      final refreshToken = await secureStorage.read(key: 'refresh_token');
      if (refreshToken == null) return false;

      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
        // Mark this request so ErrorInterceptor doesn't retry it again.
        options: Options(headers: {_retryHeader: true}),
      );

      final newToken = response.data?['token'] as String?;
      if (newToken == null) return false;

      await secureStorage.write(key: 'auth_token', value: newToken);
      talker.info('🔑 New token saved');
      return true;
    } catch (e) {
      talker.error('Token refresh request failed: $e');
      return false;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions options) {
    // Clone the original request with the retry marker so it won't
    // be intercepted by 401 handling again.
    return _dio.request<dynamic>(
      options.path,
      data: options.data,
      queryParameters: options.queryParameters,
      options: Options(
        method: options.method,
        headers: {
          ...options.headers,
          _retryHeader: true,
        },
      ),
    );
  }

  Future<void> _clearSessionAndRedirect() async {
    await secureStorage.deleteAll();
    // Use your app's router — e.g. GoRouter or auto_route
    // appRouter.go('/login');
    talker.info('🧹 Session cleared — user redirected to login');
  }

  void _logError(DioException err) {
    final status = err.response?.statusCode;
    final uri = err.requestOptions.uri;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        talker.error('⏰ Timeout on $uri');
      case DioExceptionType.connectionError:
        talker.error('🌐 No internet — $uri');
      case DioExceptionType.badResponse:
        talker.error('🔥 HTTP $status on $uri — ${err.response?.data}');
      default:
        talker.error('❓ Unknown error [${err.type}] on $uri');
    }
  }
}
