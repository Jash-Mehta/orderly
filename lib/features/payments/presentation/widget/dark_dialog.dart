import 'package:flutter/material.dart';
import 'package:orderly/core/ui/theme/colors.dart';

class DialogAction {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const DialogAction({required this.label, required this.color, required this.onTap});
}
class DarkDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final List<DialogAction> actions;

  const DarkDialog({super.key, 
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: iconColor.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: iconColor.withOpacity(0.3), width: 1),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 16),
            Text(title,
                style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.text,
                )),
            const SizedBox(height: 8),
            Text(message,
                style: const TextStyle(fontSize: 13, color: AppColors.muted, height: 1.5),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ...actions.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: a.onTap,
                child: Container(
                  width: double.infinity,
                  height: 46,
                  decoration: BoxDecoration(
                    color: a.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: a.color.withOpacity(0.3), width: 1),
                  ),
                  child: Center(
                    child: Text(a.label,
                        style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700, color: a.color,
                        )),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}