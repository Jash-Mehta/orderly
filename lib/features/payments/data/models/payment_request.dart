import 'package:equatable/equatable.dart';

class PaymentRequest extends Equatable {
  final String orderId;
  final String userId;
  final String razorpayOrderId;
  final double amount;
  final String status;

  const PaymentRequest({
    required this.orderId,
    required this.userId,
    required this.razorpayOrderId,
    required this.amount,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'user_id': userId,
      'razorpay_order_id': razorpayOrderId,
      'amount': amount,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [orderId, userId, razorpayOrderId, amount, status];
}
