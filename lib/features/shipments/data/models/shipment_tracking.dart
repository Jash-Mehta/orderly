import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:orderly/features/shipments/data/models/shipment_tracking_data.dart';

class ShipmentTrackingResponse extends Equatable {
  final int statusCode;
  final bool success;
  final String message;
  final List<ShipmentTrackingData> data;

  const ShipmentTrackingResponse({
    required this.statusCode,
    required this.success,
    required this.message,
    required this.data,
  });

  factory ShipmentTrackingResponse.fromJson(Map<String, dynamic> json) {
    return ShipmentTrackingResponse(
      statusCode: json['statusCode'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((item) => ShipmentTrackingData.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'success': success,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [statusCode, success, message, data];
}

enum ShipmentStatus {
  pending('PENDING', 'Pending', Colors.orange),
  dispatched('DISPATCHED', 'Dispatched', Colors.blue),
  inTransit('IN_TRANSIT', 'In Transit', Colors.purple),
  outForDelivery('OUT_FOR_DELIVERY', 'Out for Delivery', Colors.indigo),
  delivered('DELIVERED', 'Delivered', Colors.green);

  const ShipmentStatus(this.value, this.displayName, this.color);
  
  final String value;
  final String displayName;
  final Color color;

  static ShipmentStatus fromString(String value) {
    return ShipmentStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ShipmentStatus.pending,
    );
  }
}
