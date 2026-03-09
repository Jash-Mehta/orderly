import 'package:orderly/features/shipments/data/models/shipment_tracking.dart';

abstract class ShipmentRepository {
  Future<ShipmentTrackingResponse> getShipmentTracking(String shipmentId);
}
