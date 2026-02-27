import 'package:equatable/equatable.dart';

class PaymentVerificationRequest extends Equatable {
  final String razorpayOrderId;
  final String razorpayPaymentId;
  final String razorpaySignature;

  const PaymentVerificationRequest({
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
    required this.razorpaySignature,
  });

  Map<String, dynamic> toJson() {
    return {
      'razorpayOrderId': razorpayOrderId,
      'razorpayPaymentId': razorpayPaymentId,
      'razorpaySignature': razorpaySignature,
    };
  }

  @override
  List<Object?> get props => [razorpayOrderId, razorpayPaymentId, razorpaySignature];
}
