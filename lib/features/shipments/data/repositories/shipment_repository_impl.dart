import 'package:orderly/core/api/api_result.dart';
import 'package:orderly/core/di/service_locator.dart';

import 'package:orderly/core/utils/methods/failure/app_failure.dart';
import 'package:orderly/core/utils/methods/failure/network_failure.dart';
import 'package:orderly/features/shipments/data/models/shipment_tracking.dart';
import 'package:orderly/features/shipments/data/repositories/shipment_repository.dart';

class ShipmentRepositoryImpl implements ShipmentRepository {

  ShipmentRepositoryImpl();

  @override
  Future<ShipmentTrackingResponse> getShipmentTracking(String shipmentId) async {
    try {
      final result = await apiClient.get('/api/shipment/$shipmentId/tracking');
      
      return switch (result) {
        Success(:final value) => ShipmentTrackingResponse.fromJson(value),
        Failure(:final failure) => throw failure,
      };
    } catch (e) {
      if (e is AppFailure) {
        throw e;
      }
      throw UnexpectedAppFailure(e.toString());
    }
  }
}
