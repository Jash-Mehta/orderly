import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:orderly/core/di/service_locator.dart';
import 'package:orderly/core/utils/methods/failure/app_failure.dart';
import 'package:orderly/core/utils/methods/failure/network_failure.dart';
import 'package:orderly/core/utils/methods/api/api_result.dart';
import 'package:orderly/features/auth/data/models/auth_models.dart';
import 'package:orderly/features/auth/data/models/auth_request.dart';
import 'package:orderly/features/auth/data/repositories/auth_repository.dart';
import 'package:orderly/features/auth/domain/bloc/auth_failure.dart';


class AuthRepositoryImpl implements AuthRepository {
 

  // ── Public API ─────────────────────────────────────────────────────────────

  @override
  Future<Result<UserModel>> login(LoginRequest request) async {
    final connectivityFailure = await _checkConnectivity();
    if (connectivityFailure != null) return Failure(connectivityFailure);

    try {
      final response = await authRemoteDataSource.login(request);
      await _persistSession(response);
      talker.info('Login successful: ${response.email}');
      return Success(response);
    } on DioException catch (e, st) {
      talker.error('Remote login failed', e, st);
      return Failure(_mapDioError(e));
    } catch (e, st) {
      talker.error('Unexpected login error', e, st);
      return Failure(const UnexpectedAppFailure());
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await authRemoteDataSource.logout().onError<DioException>((e, st) {
        talker.warning('Remote logout failed, clearing locally anyway: $e');
      });

      await authLocalDataSource.clearAll();
      talker.info('Logout complete');
      return const Success(null);
    } catch (e, st) {
      talker.error('Local clearAll failed during logout', e, st);
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<UserModel?>> getCurrentUser() async {
    try {
      final user = await authLocalDataSource.getUser();
      return Success(user);
    } catch (e, st) {
      talker.error('Failed to read user from local storage', e, st);
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool>> isLoggedIn() async {
    try {
      final token = await authLocalDataSource.getToken();
      return Success(token != null && token.isNotEmpty);
    } catch (e, st) {
      talker.error('Failed to read token from local storage', e, st);
      return Failure(CacheFailure(e.toString()));
    }
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  Future<NoInternetFailure?> _checkConnectivity() async {
    final result = await connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) return const NoInternetFailure();
    return null;
  }

  Future<void> _persistSession(UserModel response) async {
    await Future.wait([
      authLocalDataSource.saveToken(response.token),
      authLocalDataSource.saveUser(response),
    ]);
  }

  AppFailure _mapDioError(DioException e) => switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout =>
          const TimeoutAppFailure(),
        DioExceptionType.connectionError => const NoInternetFailure(),
        DioExceptionType.badResponse => switch (e.response?.statusCode) {
            400 || 401 || 403 => const InvalidCredentialsFailure(),
            
            _ => UnexpectedAppFailure('HTTP ${e.response?.statusCode}'),
          },
        _ => const UnexpectedAppFailure(),
      };
}