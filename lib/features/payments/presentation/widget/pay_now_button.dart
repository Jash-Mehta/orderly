import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/core/ui/theme/colors.dart';
import 'package:orderly/features/auth/domain/bloc/auth_bloc.dart';
import 'package:orderly/features/payments/domain/bloc/payment_bloc.dart';
import 'package:orderly/features/payments/domain/bloc/payment_event.dart';
import 'package:orderly/features/payments/domain/bloc/payment_state.dart';
import 'package:orderly/features/payments/presentation/screens/payment_screen.dart';

class PayNowButton extends StatelessWidget {
  const PayNowButton({
    super.key,
    required this.widget,
  });

  final PaymentScreen widget;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
        final isLoading = state is PaymentLoading;
        return GestureDetector(
          onTap: isLoading
              ? null
              : () {
                  final authState = context.read<AuthBloc>().state;
                  if (authState is AuthAuthenticated) {
                    context.read<PaymentBloc>().add(
                      InitiateRazorpayPaymentEvent(
                        orderId: widget.orderId,
                        userId: authState.user.id,
                        amount: widget.amount,
                      ),
                    );
                  }
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 54,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isLoading
                  ? AppColors.amber.withOpacity(0.5)
                  : AppColors.amber,
              borderRadius: BorderRadius.circular(14),
              boxShadow: isLoading
                  ? []
                  : [
                      BoxShadow(
                        color: AppColors.amber.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.black54,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock_outline_rounded,
                          size: 18,
                          color: Colors.black87,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Pay \$${widget.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
