import 'package:flutter/material.dart';
import 'package:orderly/features/home/domain/bloc/home_bloc.dart';

import 'package:orderly/features/home/presentation/widgets/animated_cart_items.dart';
import 'package:orderly/features/home/presentation/widgets/cart_item_widget.dart';
import 'package:orderly/features/home/presentation/widgets/order_summary_card.dart';

class CartBody extends StatelessWidget {
  final HomeLoadedState state;
  const CartBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cart = state.cartPayload!;
    final items = cart.items;

    return Column(
      children: [
        
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return AnimatedCartItem(
                index: index,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: CartItemWidget(
                    item: items[index],
                    onRemove: () {
                      // TODO: Implement remove item functionality
                    },
                  ),
                ),
              );
            },
          ),
        ),

        
        OrderSummaryCard(cart: cart),
      ],
    );
  }
}
