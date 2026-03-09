import 'package:flutter/material.dart';

import 'package:orderly/features/shipments/data/models/shipment_tracking_data.dart';

import 'package:orderly/features/shipments/presentation/widgets/timeline_item.dart';

class AnimatedTimeline extends StatelessWidget {
  final List<ShipmentTrackingData> trackingData;
  final AnimationController controller;
  final AnimationController pulseCtrl;

  const AnimatedTimeline({super.key, 
    required this.trackingData,
    required this.controller,
    required this.pulseCtrl,
  });

  @override
  Widget build(BuildContext context) {
    if (trackingData.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(trackingData.length, (index) {
          final isFirst = index == 0;
          final isLast  = index == trackingData.length - 1;
          final data    = trackingData[index];

          // Stagger each item
          final start = (index / trackingData.length) * 0.6;
          final end   = start + 0.4;
          final itemAnim = CurvedAnimation(
            parent: controller,
            curve: Interval(start.clamp(0, 1), end.clamp(0, 1),
                curve: Curves.easeOutCubic),
          );

          return AnimatedBuilder(
            animation: itemAnim,
            builder: (_, child) => Opacity(
              opacity: itemAnim.value,
              child: Transform.translate(
                offset: Offset(-12 * (1 - itemAnim.value), 0),
                child: child,
              ),
            ),
            child: TimelineItem(
              data: data,
              isFirst: isFirst,
              isLast: isLast,
              pulseCtrl: pulseCtrl,
            ),
          );
        }),
      ),
    );
  }
}
