import 'package:equatable/equatable.dart';
import 'package:orderly/features/shipments/data/models/shipment_tracking.dart';

abstract class ShipmentState extends Equatable {
  const ShipmentState();
  
  @override
  List<Object?> get props => [];
}

class ShipmentInitial extends ShipmentState {
  const ShipmentInitial();
}

class ShipmentLoading extends ShipmentState {
  const ShipmentLoading();
}

class ShipmentLoaded extends ShipmentState {
  final ShipmentTrackingResponse trackingResponse;

  const ShipmentLoaded(this.trackingResponse);

  @override
  List<Object?> get props => [trackingResponse];
}

class ShipmentFailure extends ShipmentState {
  final String error;

  const ShipmentFailure(this.error);

  @override
  List<Object?> get props => [error];
}
