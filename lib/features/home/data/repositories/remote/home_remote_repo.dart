
import 'package:orderly/features/home/data/model/create_order_payload.dart';
import 'package:orderly/features/home/data/model/dashboard_model.dart';

abstract interface class HomeRemoteRepo {
  Future<DashboardResponseModel> fetchHomeData();
  Future<void> createOrder(CreateOrderPayload payload);
 
}