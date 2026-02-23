import 'package:dio/dio.dart';
import 'package:orderly/core/di/service_locator.dart';

/// Attaches the Bearer token to every outgoing request.
/// Uses [RequestInterceptorHandler.next] correctly inside an async context.
class AuthInterceptor extends QueuedInterceptor {
  // QueuedInterceptor ensures concurrent requests don't race
  // each other when reading/refreshing the token.

  static const _tokenKey = 'auth_token';

  // Endpoints that must never have an auth header attached.
  static const _publicPaths = {'/auth/login', '/auth/register'};

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth header for public endpoints.
    if (_publicPaths.contains(options.path)) {
      return handler.next(options);
    }

    final token = await secureStorage.read(key: _tokenKey);

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      talker.debug('🔐 Auth token attached to ${options.path}');
    }

    handler.next(options);
  }
}