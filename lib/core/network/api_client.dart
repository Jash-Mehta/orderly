import 'package:dio/dio.dart';
import 'package:orderly/core/utils/methods/failure/app_failure.dart';
import 'package:orderly/core/utils/methods/failure/network_failure.dart';
import 'package:orderly/core/utils/methods/api/api_result.dart';

/// A thin, type-safe wrapper around [Dio].
///
/// Every method returns [Result<T>] so callers never deal with
/// try/catch or DioException — error mapping is centralised here.
///
/// Usage:
///   final result = await apiClient.get<Map<String, dynamic>>('/users/me');
///   final result = await apiClient.post<Map<String, dynamic>>(
///     '/auth/login',
///     body: request.toJson(),
///   );
class ApiClient {
  ApiClient({required Dio dio}) : _dio = dio;

  final Dio _dio;

  // ── GET ────────────────────────────────────────────────────────────────────

  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return Failure(_mapDioError(e));
    } catch (e) {
      return Failure(UnexpectedAppFailure(e.toString()));
    }
  }

  // ── POST ───────────────────────────────────────────────────────────────────

  Future<Result<T>> post<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return Failure(_mapDioError(e));
    } catch (e) {
      return Failure(UnexpectedAppFailure(e.toString()));
    }
  }

  // ── PUT ────────────────────────────────────────────────────────────────────

  Future<Result<T>> put<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return Failure(_mapDioError(e));
    } catch (e) {
      return Failure(UnexpectedAppFailure(e.toString()));
    }
  }

  // ── PATCH ──────────────────────────────────────────────────────────────────

  Future<Result<T>> patch<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.patch<T>(
        path,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return Failure(_mapDioError(e));
    } catch (e) {
      return Failure(UnexpectedAppFailure(e.toString()));
    }
  }

  // ── DELETE ─────────────────────────────────────────────────────────────────

  Future<Result<T>> delete<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return Failure(_mapDioError(e));
    } catch (e) {
      return Failure(UnexpectedAppFailure(e.toString()));
    }
  }

  // ── Multipart (file upload) ────────────────────────────────────────────────

  Future<Result<T>> upload<T>(
    String path, {
    required FormData formData,
    void Function(int sent, int total)? onSendProgress,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        options: options ?? Options(contentType: 'multipart/form-data'),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return Failure(_mapDioError(e));
    } catch (e) {
      return Failure(UnexpectedAppFailure(e.toString()));
    }
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  Result<T> _handleResponse<T>(Response<T> response) {
    final data = response.data;

    if (data == null) {
      // For endpoints that return 204 No Content (e.g. logout, delete).
      // Callers using Result<void> will receive Success(null).
      return Success(null as T);
    }

    return Success(data);
  }

  AppFailure _mapDioError(DioException e) => switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout =>
          const TimeoutAppFailure(),
        DioExceptionType.connectionError => const NoInternetFailure(),
        DioExceptionType.badResponse => switch (e.response?.statusCode) {
            400 => const BadRequestFailure(),
            401 || 403 => const UnauthorizedFailure(),
            404 => const NotFoundFailure(),
            500 => const ServerAppFailure(),
            _ => UnexpectedAppFailure('HTTP ${e.response?.statusCode}'),
          },
        _ => const UnexpectedAppFailure(),
      };
}