import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly/core/ui/theme/colors.dart';
import 'package:orderly/features/payments/presentation/widget/dark_dialog.dart';
import 'package:orderly/features/shipments/presentation/screens/shipment_tracking_screen.dart';

void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (context) => DarkDialog(
      icon: Icons.check_circle_outline_rounded,
      iconColor: AppColors.green,
      title: 'Payment Successful',
      message: 'Your payment has been processed successfully.',
      actions: [
        DialogAction(
          label: 'Track Shipment',
          color: AppColors.amber,
          onTap: () {
            const shipmentId = '463e788d-e538-4725-9b05-c26a81e3e1fb';
            final args = ShipmentTrackingArgs(shipmentId: shipmentId);
            context.pushNamed('shipment-tracking', extra: args);
          },
        ),
        DialogAction(
          label: 'Go to Home',
          color: AppColors.muted,
          onTap: () => context.go('/home'),
        ),
      ],
    ),
  );
}

void showErrorDialog(BuildContext context, String error) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (context) => DarkDialog(
      icon: Icons.error_outline_rounded,
      iconColor: AppColors.red,
      title: 'Payment Failed',
      message: error,
      actions: [
        DialogAction(
          label: 'OK',
          color: AppColors.amber,
          onTap: () {
            const shipmentId = '22e8b1aa-a86c-4de4-a875-9c206f66529f';
            final args = ShipmentTrackingArgs(shipmentId: shipmentId);
            context.pushNamed('shipment-tracking', extra: args);
          },
        ),
      ],
    ),
  );
}
