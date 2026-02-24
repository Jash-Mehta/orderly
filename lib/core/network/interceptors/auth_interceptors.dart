import 'package:dio/dio.dart';
import 'package:orderly/core/di/service_locator.dart';

class AuthInterceptor extends QueuedInterceptor {
  static const _tokenKey = 'auth_token';
  static const _publicPaths = {'/auth/login', '/auth/register'};

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
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