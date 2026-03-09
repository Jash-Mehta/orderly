import 'package:flutter/material.dart';
import 'package:orderly/core/ui/theme/colors.dart';

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const SummaryRow({super.key, 
    required this.label,
    required this.value,
    this.valueColor,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: labelStyle ??
              const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.muted,
              ),
        ),
        Text(
          value,
          style: valueStyle ??
              TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.text,
              ),
        ),
      ],
    );
  }
}