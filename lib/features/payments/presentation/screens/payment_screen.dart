import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly/core/ui/theme/colors.dart';

import 'package:orderly/features/payments/domain/bloc/payment_bloc.dart';

import 'package:orderly/features/payments/domain/bloc/payment_state.dart';
import 'package:orderly/features/payments/presentation/widget/address_section.dart';

import 'package:orderly/features/payments/presentation/widget/pay_now_button.dart';
import 'package:orderly/features/payments/presentation/widget/payment_method_tile.dart';
import 'package:orderly/features/payments/presentation/widget/section_label.dart';
import 'package:orderly/features/payments/presentation/widget/summary_row.dart';
import 'package:orderly/features/payments/utils/methods.dart';

class PaymentScreen extends StatefulWidget {
  final String orderId;
  final double amount;

  const PaymentScreen({super.key, required this.orderId, required this.amount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with TickerProviderStateMixin {
  late final AnimationController _headerController;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _headerFade;

  // Content stagger
  late final AnimationController _contentController;

  String _selectedPaymentMethod = 'razorpay';
  String _selectedAddress = '123 Main Street, Apt 4B, New York, NY 10001';

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _headerController,
            curve: Curves.easeOutCubic,
          ),
        );
    _headerFade = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeIn,
    );

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _contentController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Animation<double> _staggerFade(double start, double end) => CurvedAnimation(
    parent: _contentController,
    curve: Interval(start, end, curve: Curves.easeOut),
  );

  Animation<Offset> _staggerSlide(double start, double end) =>
      Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _contentController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: BlocListener<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is PaymentSuccess) {
              showSuccessDialog(context);
            } else if (state is PaymentFailure) {
              showErrorDialog(context, state.error);
            }
          },
          child: Column(
            children: [
              SlideTransition(
                position: _headerSlide,
                child: FadeTransition(
                  opacity: _headerFade,
                  child: _buildHeader(context),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order summary
                      FadeTransition(
                        opacity: _staggerFade(0.0, 0.5),
                        child: SlideTransition(
                          position: _staggerSlide(0.0, 0.5),
                          child: _buildOrderSummary(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      FadeTransition(
                        opacity: _staggerFade(0.2, 0.7),
                        child: SlideTransition(
                          position: _staggerSlide(0.2, 0.7),
                          child: _buildPaymentMethodSection(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      FadeTransition(
                        opacity: _staggerFade(0.4, 0.9),
                        child: SlideTransition(
                          position: _staggerSlide(0.4, 0.9),
                          child: AddressSection(
                            selectedAddress: _selectedAddress,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      FadeTransition(
                        opacity: _staggerFade(0.6, 1.0),
                        child: PayNowButton(widget: widget),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.text,
                  size: 19,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Payment',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.text,
                letterSpacing: -0.6,
              ),
            ),
          ),
          // Secure badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.green.withOpacity(0.25),
                width: 1,
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline, size: 11, color: AppColors.green),
                SizedBox(width: 4),
                Text(
                  'Secure',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Order Summary'),
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A2535), Color(0xFF141C28)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.amber.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.amber.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Glow
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.amber.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SummaryRow(
                      label: 'Order ID',
                      value: '#${widget.orderId}',
                      valueStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(height: 1, color: AppColors.border),
                    const SizedBox(height: 16),
                    SummaryRow(
                      label: 'Total Amount',
                      value: '\$${widget.amount.toStringAsFixed(2)}',
                      valueStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.amber,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Payment Method'),
        PaymentMethodTile(
          value: 'razorpay',
          groupValue: _selectedPaymentMethod,
          label: 'Razorpay',
          subtitle: 'Cards · UPI · Wallets · Net Banking',
          icon: Icons.payment_rounded,
          iconColor: AppColors.blue,
          onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
        ),
      ],
    );
  }
}
