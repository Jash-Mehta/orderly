import 'package:bloc/bloc.dart';
import 'package:orderly/features/shipments/data/models/shipment_tracking.dart';
import 'package:orderly/features/shipments/data/repositories/shipment_repository.dart';
import 'package:orderly/features/shipments/domain/bloc/shipment_event.dart';
import 'package:orderly/features/shipments/domain/bloc/shipment_state.dart';

class ShipmentBloc extends Bloc<ShipmentEvent, ShipmentState> {
  final ShipmentRepository repository;

  ShipmentBloc(this.repository) : super(const ShipmentInitial()) {
    on<GetShipmentTracking>(_onGetShipmentTracking);
    on<RefreshShipmentTracking>(_onRefreshShipmentTracking);
  }

  Future<void> _onGetShipmentTracking(
    GetShipmentTracking event,
    Emitter<ShipmentState> emit,
  ) async {
    emit(const ShipmentLoading());
    try {
      final trackingResponse = await repository.getShipmentTracking(event.shipmentId);
      emit(ShipmentLoaded(trackingResponse));
    } catch (e) {
      emit(ShipmentFailure(e.toString()));
    }
  }

  Future<void> _onRefreshShipmentTracking(
    RefreshShipmentTracking event,
    Emitter<ShipmentState> emit,
  ) async {
    try {
      final trackingResponse = await repository.getShipmentTracking(event.shipmentId);
      emit(ShipmentLoaded(trackingResponse));
    } catch (e) {
      emit(ShipmentFailure(e.toString()));
    }
  }
}
