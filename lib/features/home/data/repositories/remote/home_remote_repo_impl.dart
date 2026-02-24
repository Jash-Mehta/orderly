
import 'package:orderly/constants/api_endpoints.dart';

import 'package:orderly/core/api/api_result.dart';
import 'package:orderly/core/di/service_locator.dart';

import 'package:orderly/features/home/data/model/create_order_payload.dart';
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

  @override
  Future<void> createOrder(CreateOrderPayload payload) async {
    
      final result = await apiClient.post(
        ApiEndpoints.orders.createOrder,
        body: _payloadToJson(payload),
      );
      
      switch (result) {
        case Success():
          talker.info("Order created successfully");
          return;
        case Failure(:final failure):
          throw failure;
      
    } 
  }

    Map<String, dynamic> _payloadToJson(CreateOrderPayload payload) {
    return {
      'customer_id': payload.userId,
      'total_amount': payload.totalAmount,
      'status': payload.status,
      'items': payload.items.map((item) => {
        'product_id': item.productId,
        'quantity': item.quantity,
        'amount': item.amount,
      }).toList(),
    };
  }
}