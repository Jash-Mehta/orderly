import 'package:orderly/constants/api_endpoints.dart';
import 'package:orderly/core/api/api_result.dart';
import 'package:orderly/core/di/service_locator.dart';
import 'package:orderly/features/home/data/model/dashboard_model.dart';
import 'package:orderly/features/home/data/repositories/remote/home_remote_repo.dart';

class HomeRemoteRepoImpl implements HomeRemoteRepo {
  @override
  Future<DashboardResponseModel> fetchHomeData() async {
    final result = await apiClient.get(ApiEndpoints.home.home);
    return switch (result) {
      Success(:final value) => DashboardResponseModel.fromJson(value),
      Failure(:final failure) => throw failure,
    };
  }
}