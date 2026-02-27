import 'package:orderly/features/payments/data/models/payment.dart';

abstract class PaymentRepository {
  Future<Payment> createPayment({
    required String orderId,
    required String userId,
    required String razorpayOrderId,
    required double amount,
    required String status,
  });

  Future<Payment> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  });

  Future<Payment?> getPaymentByOrderId(String orderId);
  Future<Payment?> getPaymentByRazorpayId(String razorpayPaymentId);
  Future<List<Payment>> getUserPayments(String userId);
}
