import 'package:flutter/material.dart';
import 'package:orderly/core/ui/theme/colors.dart';
import 'package:orderly/features/payments/presentation/widget/section_label.dart';

class AddressSection extends StatelessWidget {
  const AddressSection({
    super.key,
    required this.selectedAddress,
  });

  final String selectedAddress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Delivery Address'),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.blue.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      selectedAddress,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.muted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.muted,
                size: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
