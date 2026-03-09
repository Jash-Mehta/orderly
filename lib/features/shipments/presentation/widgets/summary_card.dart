import 'package:flutter/material.dart';
import 'package:orderly/core/ui/theme/colors.dart';
import 'package:orderly/features/shipments/data/models/shipment_tracking.dart';
import 'package:orderly/features/shipments/data/models/shipment_tracking_data.dart';
import 'package:orderly/features/shipments/presentation/widgets/info_chip.dart';
import 'package:orderly/features/shipments/presentation/widgets/pulsing_badge.dart';


class SummaryCard extends StatelessWidget {
  final String shipmentId;
  final List<ShipmentTrackingData> trackingData;
  final AnimationController pulseCtrl;

  const SummaryCard({super.key, 
    required this.shipmentId,
    required this.trackingData,
    required this.pulseCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final latest = trackingData.isNotEmpty ? trackingData.first : null;
    final status = latest != null ? ShipmentStatus.fromString(latest.status) : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A2535), Color(0xFF141C28)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.amber.withOpacity(0.22), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.amber.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.amber.withOpacity(0.1),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TRACKING NUMBER',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.muted,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  shipmentId,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.amber,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 18),

                // Route row
                const Row(
                  children: [
                    Expanded(child: InfoChip(label: 'Origin', value: 'New York, NY')),
                    SizedBox(width: 1, height: 36,
                        child: ColoredBox(color: AppColors.border)),
                    Expanded(child: InfoChip(label: 'Destination', value: 'Los Angeles, CA')),
                    SizedBox(width: 1, height: 36,
                        child: ColoredBox(color: AppColors.border)),
                    Expanded(child: InfoChip(label: 'Est. Arrival', value: 'Mar 09, 2026')),
                  ],
                ),

                const SizedBox(height: 16),

                
                if (status != null)
                  PulsingBadge(status: status, pulseCtrl: pulseCtrl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
