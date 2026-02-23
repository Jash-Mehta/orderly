  import 'package:orderly/core/api/api_result.dart';
import 'package:orderly/features/home/data/model/dashboard_model.dart';

abstract interface class HomeRepositories {
  Future<Result<DashboardResponseModel>> fetchHomeData();
 
}