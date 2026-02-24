 import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:orderly/core/api/api_result.dart';
import 'package:orderly/core/di/service_locator.dart';
import 'package:orderly/core/utils/methods/failure/app_failure.dart';
import 'package:orderly/core/utils/methods/failure/network_failure.dart';
import 'package:orderly/features/auth/domain/bloc/auth_failure.dart';

import 'package:orderly/features/home/data/model/dashboard_model.dart';
import 'package:orderly/features/home/data/model/create_order_payload.dart';
import 'package:orderly/features/home/data/repositories/home_repo.dart';
import 'package:orderly/features/home/data/repositories/remote/home_remote_repo.dart';
import 'package:orderly/constants/api_endpoints.dart';

class HomeRepoImpl implements HomeRepositories{
  @override
  Future<Result<DashboardResponseModel>> fetchHomeData() async {
    final connectivityFailure = await _checkConnectivity();
    if (connectivityFailure != null) return Failure(connectivityFailure);
    try {
      final response = await homeRemoteDataSource.fetchHomeData();
      
      talker.info("Home Data Fetch Succesfully");
      return Success(response);
    } on DioException catch (e, st) {
      talker.error('Home failed', e, st);
      return Failure(_mapDioError(e));
    } catch (e, st) {
      talker.error('Unexpected home error', e, st);
      return Failure(const UnexpectedAppFailure());
    }
  }

  @override
  Future<Result<void>> createOrder(CreateOrderPayload payload) async {
    final connectivityFailure = await _checkConnectivity();
    if (connectivityFailure != null) return Failure(connectivityFailure);
   try {
      final response = await homeRemoteDataSource.createOrder(payload);
     return Success(response);
   }on DioException catch (e, st) {
      talker.error('Home failed', e, st);
      return Failure(_mapDioError(e));
    } catch (e, st) {
      talker.error('Unexpected home error', e, st);
      return Failure(const UnexpectedAppFailure());
    }
  }




  Future<NoInternetFailure?> _checkConnectivity() async {
    final result = await connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) return const NoInternetFailure();
    return null;
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