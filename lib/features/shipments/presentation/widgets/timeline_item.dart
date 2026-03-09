import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orderly/core/ui/theme/colors.dart';
import 'package:orderly/features/shipments/data/models/shipment_tracking.dart';
import 'package:orderly/features/shipments/data/models/shipment_tracking_data.dart';
import 'package:orderly/features/shipments/presentation/widgets/dot.dart';
import 'package:orderly/features/shipments/presentation/widgets/status_tag.dart';


class TimelineItem extends StatelessWidget {
  final ShipmentTrackingData data;
  final bool isFirst;
  final bool isLast;
  final AnimationController pulseCtrl;

  const TimelineItem({
    required this.data,
    required this.isFirst,
    required this.isLast,
    required this.pulseCtrl,
  });

  static const double dotSize = 14.0;
  static const double lineWidth = 1.5;
  static const double leftPad = 28.0;

  @override
  Widget build(BuildContext context) {
    final status = ShipmentStatus.fromString(data.status);
    final color  = status.color;
    final dateFormat = DateFormat('MMM dd, yyyy · hh:mm a');

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Left: dot + line ──
          SizedBox(
            width: leftPad,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Top line
                if (!isFirst)
                  Positioned(
                    top: 0,
                    bottom: null,
                    child: Container(
                      width: lineWidth,
                      height: 14,
                      color: isFirst
                          ? color.withOpacity(0.5)
                          : AppColors.border.withOpacity(0.5),
                    ),
                  ),
                // Dot
                Positioned(
                  top: 14,
                  child: Dot(
                    color: color,
                    isFirst: isFirst,
                    pulseCtrl: pulseCtrl,
                  ),
                ),
                // Bottom line
                if (!isLast)
                  Positioned(
                    top: 14 + dotSize,
                    bottom: 0,
                    child: Container(
                      width: lineWidth,
                      color: AppColors.border.withOpacity(0.5),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          // ── Right: card ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isFirst
                      ? const Color(0xFF1A2535)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isFirst
                        ? color.withOpacity(0.28)
                        : AppColors.border,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status tag
                    StatusTag(status: status),
                    const SizedBox(height: 8),

                    // Title + time
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            status.displayName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          dateFormat.format(data.happenedAt.toLocal()),
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    // Message
                    Text(
                      data.message,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.muted,
                        height: 1.5,
                      ),
                    ),

                    // Location
                    if (data.location != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 13, color: AppColors.blue),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              data.location!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
