import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly/features/auth/domain/bloc/auth_bloc.dart';
import 'package:orderly/features/home/domain/bloc/home_bloc.dart';
import 'package:orderly/features/home/presentation/widgets/submit_button.dart';

class OrderSummaryCard extends StatelessWidget {
  final dynamic cart; // CartPayload
  const OrderSummaryCard({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Divider pill
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6F7),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Price Summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Subtotal',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF1A1A2E),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Delivery Fee',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      'FREE',
                      style: TextStyle(
                        color: Color(0xFF2ECC71),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: Color(0xFFE5E7EB)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        color: Color(0xFF1A1A2E),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF1A1A2E),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Submit Button
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              final isLoading = state is HomeLoadingState;
              return SubmitButton(
                isLoading: isLoading,
                onPressed: isLoading
                    ? null
                    : () {
                        // Create order first, then navigate to payment
                        context.read<HomeBloc>().add(CreateOrder());
                        
                        // After order is created, navigate to payment screen
                        // For now, we'll navigate directly with mock order ID
                        final authState = context.read<AuthBloc>().state;
                        if (authState is AuthAuthenticated) {
                          context.push('/payment?orderId=order_${DateTime.now().millisecondsSinceEpoch}&amount=${cart.totalAmount}');
                        }
                      },
              );
            },
          ),
        ],
      ),
    );
  }
}
