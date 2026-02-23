import 'package:dio/dio.dart';
import 'package:orderly/core/network/interceptors/auth_interceptors.dart';
import 'package:orderly/core/network/interceptors/error_interceptors.dart';
import 'package:orderly/core/network/interceptors/logging_interceptors.dart';

class DioClient {
  DioClient._();

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'http://localhost:3000',
        ),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      LoggingInterceptor(),
      AuthInterceptor(),
      ErrorInterceptor(dio),
    ]);

    return dio;
  }
}