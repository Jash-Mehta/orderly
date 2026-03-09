import 'package:flutter/material.dart';
import 'package:orderly/features/shipments/presentation/widgets/timeline_item.dart';

class Dot extends StatelessWidget {
  final Color color;
  final bool isFirst;
  final AnimationController pulseCtrl;

  const Dot({required this.color, required this.isFirst, required this.pulseCtrl});

  @override
  Widget build(BuildContext context) {
    const size = TimelineItem.dotSize;

    if (!isFirst) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.6), width: 2),
        ),
      );
    }

    // Active: pulsing ring
    return AnimatedBuilder(
      animation: pulseCtrl,
      builder: (_, __) {
        final ringSize = size + 6 + pulseCtrl.value * 4;
        return SizedBox(
          width: ringSize,
          height: ringSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: (1 - pulseCtrl.value) * 0.35,
                child: Container(
                  width: ringSize,
                  height: ringSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 1.5),
                  ),
                ),
              ),
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.45),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
