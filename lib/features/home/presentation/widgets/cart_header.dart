import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly/core/ui/theme/colors.dart';

class CartHeader extends StatelessWidget {
  final int itemCount;
  const CartHeader({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MY CART',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.5,
                    height: 1,
                    color: Colors.white
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  itemCount == 0
                      ? 'Nothing here yet'
                      : '$itemCount ${itemCount == 1 ? 'item' : 'items'} in your bag',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    letterSpacing: 0.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.chineseBlue.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
