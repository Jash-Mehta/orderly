import 'package:flutter/material.dart';
import 'package:orderly/features/shipments/data/models/shipment_tracking.dart';
import 'package:orderly/features/shipments/presentation/screens/shipment_tracking_screen.dart';

class StatusTag extends StatelessWidget {
  final ShipmentStatus status;
  const StatusTag({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: status.color.withOpacity(0.22), width: 1),
      ),
      child: Text(
        status.rawTag.toUpperCase(),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: status.color,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
