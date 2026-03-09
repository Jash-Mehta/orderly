import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final String id;
  final String orderId;
  final String userId;
  final String razorpayOrderId;
  final double amount;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Payment({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.razorpayOrderId,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      userId: json['user_id'] as String,
      razorpayOrderId: json['razorpay_order_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'user_id': userId,
      'razorpay_order_id': razorpayOrderId,
      'amount': amount,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        orderId,
        userId,
        razorpayOrderId,
        amount,
        status,
        createdAt,
        updatedAt,
      ];
}
