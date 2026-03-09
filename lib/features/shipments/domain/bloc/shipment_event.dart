import 'package:equatable/equatable.dart';

abstract class ShipmentEvent extends Equatable {
  const ShipmentEvent();
  
  @override
  List<Object?> get props => [];
}

class GetShipmentTracking extends ShipmentEvent {
  final String shipmentId;

  const GetShipmentTracking(this.shipmentId);

  @override
  List<Object?> get props => [shipmentId];
}

class RefreshShipmentTracking extends ShipmentEvent {
  final String shipmentId;

  const RefreshShipmentTracking(this.shipmentId);

  @override
  List<Object?> get props => [shipmentId];
}
