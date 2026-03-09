import 'package:flutter/material.dart';
import 'package:orderly/core/ui/theme/colors.dart';


class InfoChip extends StatelessWidget {
  final String label;
  final String value;
  const InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 10, color: AppColors.muted, letterSpacing: 0.6)),
          const SizedBox(height: 3),
          Text(value,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.text)),
        ],
      ),
    );
  }
}
