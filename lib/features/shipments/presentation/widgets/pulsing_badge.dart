import 'package:flutter/material.dart';
import 'package:orderly/features/shipments/data/models/shipment_tracking.dart';

class PulsingBadge extends StatelessWidget {
  final ShipmentStatus status;
  final AnimationController pulseCtrl;
  const PulsingBadge({super.key, required this.status, required this.pulseCtrl});

  @override
  Widget build(BuildContext context) {
    final color = status.color;
    return AnimatedBuilder(
      animation: pulseCtrl,
      builder: (_, _) {
        final dotOpacity = 0.5 + pulseCtrl.value * 0.5;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Opacity(
                opacity: dotOpacity,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: color.withOpacity(0.5), blurRadius: 4)
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 7),
              Text(
                status.displayName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
