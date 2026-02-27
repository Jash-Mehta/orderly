import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class CreatePaymentEvent extends PaymentEvent {
  final String orderId;
  final String userId;
  final double amount;

  const CreatePaymentEvent({
    required this.orderId,
    required this.userId,
    required this.amount,
  });

  @override
  List<Object?> get props => [orderId, userId, amount];
}

class InitiateRazorpayPaymentEvent extends PaymentEvent {
  final String orderId;
  final String userId;
  final double amount;

  const InitiateRazorpayPaymentEvent({
    required this.orderId,
    required this.userId,
    required this.amount,
  });

  @override
  List<Object?> get props => [orderId, userId, amount];
}

class VerifyPaymentEvent extends PaymentEvent {
  final String razorpayOrderId;
  final String razorpayPaymentId;
  final String razorpaySignature;

  const VerifyPaymentEvent({
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
    required this.razorpaySignature,
  });

  @override
  List<Object?> get props => [razorpayOrderId, razorpayPaymentId, razorpaySignature];
}

class ResetPaymentStateEvent extends PaymentEvent {
  const ResetPaymentStateEvent();
}
