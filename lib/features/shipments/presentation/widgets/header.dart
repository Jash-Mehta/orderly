import 'package:flutter/material.dart';
import 'package:orderly/core/ui/theme/colors.dart';


class Header extends StatelessWidget {
  final VoidCallback onBack;
  const Header({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.text,
              size: 19,
            ),
          ),
          const SizedBox(width: 14),
          const Text(
            'Shipment Tracking',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
              letterSpacing: -0.6,
            ),
          ),
        ],
      ),
    );
  }
}
