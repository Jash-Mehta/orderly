import 'package:equatable/equatable.dart';

class ShipmentTrackingData extends Equatable {
  final String id;
  final String shipmentId;
  final String status;
  final String message;
  final String? location;
  final DateTime happenedAt;
  final DateTime createdAt;

  const ShipmentTrackingData({
    required this.id,
    required this.shipmentId,
    required this.status,
    required this.message,
    this.location,
    required this.happenedAt,
    required this.createdAt,
  });

  factory ShipmentTrackingData.fromJson(Map<String, dynamic> json) {
    return ShipmentTrackingData(
      id: json['id'] as String,
      shipmentId: json['shipment_id'] as String,
      status: json['status'] as String,
      message: json['message'] as String,
      location: json['location'] as String?,
      happenedAt: DateTime.parse(json['happened_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shipment_id': shipmentId,
      'status': status,
      'message': message,
      'location': location,
      'happened_at': happenedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, shipmentId, status, message, location, happenedAt, createdAt];
}
