import 'package:equatable/equatable.dart';
import 'package:orderly/core/utils/methods/map.dart';
import 'package:orderly/features/home/data/model/create_order_item.dart';

class CreateOrderPayload extends Equatable {
  final String userId;
  final double totalAmount;
  final String status;
  final List<CreateOrderItem> items;

  const CreateOrderPayload({
    required this.userId,
    required this.totalAmount,
    required this.status,
    required this.items,
  });

  factory CreateOrderPayload.fromJson(Map<String, dynamic> map) {
    return CreateOrderPayload(
      userId: map.getString('customer_id'),
      totalAmount: map.getDouble('totalAmount'),
      status: map.getString('status'),
      items: (map['items'] as List<dynamic>? ?? [])
          .map((e) => CreateOrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  CreateOrderPayload copyWith({
    String? userId,
    double? totalAmount,
    String? status,
    List<CreateOrderItem>? items,
  }) {
    return CreateOrderPayload(
      userId: userId ?? this.userId,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [userId, totalAmount, status, items];
}