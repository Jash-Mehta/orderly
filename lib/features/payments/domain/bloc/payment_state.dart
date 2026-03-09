import 'package:equatable/equatable.dart';
import 'package:orderly/features/payments/data/models/payment.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

class PaymentLoading extends PaymentState {
  const PaymentLoading();
}

class PaymentCreated extends PaymentState {
  final Payment payment;

  const PaymentCreated(this.payment);

  @override
  List<Object?> get props => [payment];
}

class RazorpayPaymentInitiated extends PaymentState {
  final String razorpayOrderId;
  final String orderId;
  final double amount;

  const RazorpayPaymentInitiated({
    required this.razorpayOrderId,
    required this.orderId,
    required this.amount,
  });

  @override
  List<Object?> get props => [razorpayOrderId, orderId, amount];
}

class PaymentVerified extends PaymentState {
  final Payment payment;

  const PaymentVerified(this.payment);

  @override
  List<Object?> get props => [payment];
}

class PaymentSuccess extends PaymentState {
  final Payment payment;

  const PaymentSuccess(this.payment);

  @override
  List<Object?> get props => [payment];
}

class PaymentFailure extends PaymentState {
  final String error;

  const PaymentFailure(this.error);

  @override
  List<Object?> get props => [error];
}
