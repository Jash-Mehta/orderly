import 'package:flutter/material.dart';
import 'package:orderly/core/ui/theme/colors.dart';
import 'package:orderly/features/home/data/model/create_order_item.dart';




class CartItemWidget extends StatelessWidget {
  final CreateOrderItem item;
  final VoidCallback onRemove;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: const Color(0xFF1C2330),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              clipBehavior: Clip.antiAlias,
              child: item.image.isNotEmpty
                  ? Image.network(
                      item.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildPlaceholder(),
                      loadingBuilder: (_, child, progress) {
                        if (progress == null) return child;
                        return _buildPlaceholder();
                      },
                    )
                  : _buildPlaceholder(),
            ),
            const SizedBox(width: 14),

            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand
                  Text(
                    item.brandName,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.muted,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 3),

                  
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                      letterSpacing: -0.3,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  
                  Row(
                    children: [
                      
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C2330),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border, width: 1),
                        ),
                        child: Text(
                          'Qty: ${item.quantity}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.muted,
                          ),
                        ),
                      ),

                      const Spacer(),

                      
                      Text(
                        '\$${item.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.amber,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            
            GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.red.withOpacity(0.2), width: 1),
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.red,
                  size: 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFF1C2330),
      child: const Icon(
        Icons.image_outlined,
        size: 28,
        color: AppColors.muted,
      ),
    );
  }
}