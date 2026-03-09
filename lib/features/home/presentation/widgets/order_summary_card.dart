import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly/core/ui/theme/colors.dart';
import 'package:orderly/core/ui/widgets/custom_button.dart';
import 'package:orderly/features/auth/domain/bloc/auth_bloc.dart';
import 'package:orderly/features/home/domain/bloc/home_bloc.dart';
import 'package:orderly/features/home/presentation/widgets/summary_row.dart';


class OrderSummaryCard extends StatelessWidget {
  final dynamic cart; // CartPayload
  const OrderSummaryCard({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          Center(
            child: Container(
              width: 36,
              height: 3,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Column(
              children: [
                SummaryRow(
                  label: 'Subtotal',
                  value: '\$${cart.totalAmount.toStringAsFixed(2)}',
                  valueColor: AppColors.text,
                ),
                const SizedBox(height: 12),
                SummaryRow(
                  label: 'Delivery Fee',
                  value: 'FREE',
                  valueColor: AppColors.green,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Container(height: 1, color: AppColors.border),
                ),
                SummaryRow(
                  label: 'Total',
                  value: '\$${cart.totalAmount.toStringAsFixed(2)}',
                  labelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                  valueStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.amber,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ── Submit button ──
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              final isLoading = state is HomeLoadingState;
              return CustomButton(
                text: 'Proceed to Checkout',
                onPressed: isLoading
                    ? null
                    : () {
                        context.read<HomeBloc>().add(CreateOrder());
                        final authState = context.read<AuthBloc>().state;
                        if (authState is AuthAuthenticated) {
                          context.push(
                            '/payment?orderId=order_${DateTime.now().millisecondsSinceEpoch}&amount=${cart.totalAmount}',
                          );
                        }
                      },
                isLoading: isLoading,
                backgroundColor: AppColors.amber,
                textColor: Colors.black,
                height: 54,
                borderRadius: 14,
                prefixIcon: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 18,
                  color: Colors.black,
                ),
                enableAnimation: true,
              );
            },
          ),
        ],
      ),
    );
  }
}
