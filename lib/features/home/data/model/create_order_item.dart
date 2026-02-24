import 'package:equatable/equatable.dart';
import 'package:orderly/core/utils/methods/map.dart';

class CreateOrderItem extends Equatable {
  final String productId;
  final String name;
  final String brandName;
  final String image;
  final int quantity;
  final double amount; 

  const CreateOrderItem({
    required this.productId,
    required this.name,
    required this.brandName,
    required this.image,
    required this.quantity,
    required this.amount,
  });

  factory CreateOrderItem.fromJson(Map<String, dynamic> map) {
    return CreateOrderItem(
      productId: map.getString('product_id'),
      quantity: map.getInt('quantity'),
      amount: map.getDouble('amount'), name: map.getString("name"), brandName: map.getString('brand_name'), image: map.getString('image'),
    );
  }

  CreateOrderItem copyWith({int? quantity, double? amount, String? name, String? brandName, String? image}) {
    return CreateOrderItem(
      productId: productId,
      quantity: quantity ?? this.quantity,
      amount: amount ?? this.amount, name: name ?? this.name, brandName: brandName ?? this.brandName, image: image ?? this.image,
    );
  }

  @override
  List<Object?> get props => [productId, quantity, amount, name, brandName, image];
}