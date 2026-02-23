import 'package:dio/dio.dart';
import 'package:orderly/core/di/service_locator.dart';
import 'package:orderly/core/api/api_error_response.dart';
import 'package:orderly/core/api/api_result.dart';
import 'package:orderly/core/utils/methods/failure/app_failure.dart';
import 'package:orderly/core/utils/methods/failure/network_failure.dart';

class ApiClient {
  ApiClient({required Dio dio}) : _dio = dio;

  final Dio _dio;

  // ── GET ────────────────────────────────────────────────────────────────────

  Future<Result<Map<String, dynamic>>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
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

  Future<Result<Map<String, dynamic>>> post(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
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

  Future<Result<Map<String, dynamic>>> put(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
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

  Future<Result<Map<String, dynamic>>> patch(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
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

  Future<Result<Map<String, dynamic>>> delete(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
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

  // ── Upload ─────────────────────────────────────────────────────────────────

  Future<Result<Map<String, dynamic>>> upload(
    String path, {
    required FormData formData,
    void Function(int sent, int total)? onSendProgress,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
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

  Result<Map<String, dynamic>> _handleResponse(
    Response<Map<String, dynamic>> response,
  ) {
    final data = response.data;
    if (data == null) return const Success({});
    return Success(data);
  }

  /// Extracts the server error body from DioException and maps it
  /// to a typed [AppFailure] using [ApiErrorResponse].
  AppFailure _mapDioError(DioException e) {
    // ── Bad response — server returned an error body ───────────────────────
    if (e.type == DioExceptionType.badResponse) {
      final errorBody = _parseErrorBody(e);
      final message = errorBody?.displayMessage;
      final code = errorBody?.error?.code;

      talker.warning(
        'Server error | '
        'status: ${e.response?.statusCode} | '
        'code: $code | '
        'message: $message',
      );

      return switch (e.response?.statusCode) {
        400 => BadRequestFailure(message ?? 'Invalid request.'),
        401 => UnauthorizedFailure(message ?? 'Session expired.'),
        403 => UnauthorizedFailure(message ?? 'Access denied.'),
        404 => NotFoundFailure(message ?? 'Resource not found.'),
        500 => ServerAppFailure(message ?? 'Server error.'),
        _ => UnexpectedAppFailure(message ?? 'Unexpected error.'),
      };
    }

    // ── Network / timeout errors — no server body ──────────────────────────
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        const TimeoutAppFailure(),
      DioExceptionType.connectionError => const NoInternetFailure(),
      _ => UnexpectedAppFailure(e.message ?? 'Unexpected error.'),
    };
  }

  /// Safely parses the error response body.
  /// Returns null if the body is missing or malformed.
  ApiErrorResponse? _parseErrorBody(DioException e) {
    try {
      final data = e.response?.data;
      if (data == null) return null;

      // Dio may return the body as a Map or a String depending on
      // the response content-type and interceptor configuration.
      if (data is Map<String, dynamic>) {
        return ApiErrorResponse.fromJson(data);
      }

      return null;
    } catch (_) {
      return null;
    }
  }
}
