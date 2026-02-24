  import 'package:orderly/core/api/api_result.dart';
import 'package:orderly/features/home/data/model/dashboard_model.dart';
import 'package:orderly/features/home/data/model/create_order_payload.dart';

abstract interface class HomeRepositories {
  Future<Result<DashboardResponseModel>> fetchHomeData();
  Future<Result<void>> createOrder(CreateOrderPayload payload);
}