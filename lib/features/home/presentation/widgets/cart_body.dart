import 'package:flutter/material.dart';
import 'package:orderly/core/ui/theme/colors.dart';
import 'package:orderly/features/home/domain/bloc/home_bloc.dart';
import 'package:orderly/features/home/presentation/widgets/cart_item_widget.dart';
import 'package:orderly/features/home/presentation/widgets/order_summary_card.dart';


class CartBody extends StatelessWidget {
  final HomeLoadedState state;
  const CartBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cart  = state.cartPayload!;
    final items = cart.items;

    return Column(
      children: [
        
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CartItemWidget(
                  item: items[index],
                  onRemove: () {
                    // TODO: Implement remove item functionality
                  },
                ),
              );
            },
          ),
        ),

        
        _DarkOrderSummaryWrapper(
          child: OrderSummaryCard(cart: cart),
        ),
      ],
    );
  }
}

class _DarkOrderSummaryWrapper extends StatelessWidget {
  final Widget child;
  const _DarkOrderSummaryWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: const Border(
          top: BorderSide(color: AppColors.border, width: 1),
          left: BorderSide(color: AppColors.border, width: 1),
          right: BorderSide(color: AppColors.border, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: child,
    );
  }
}