import 'package:equatable/equatable.dart';
import 'package:orderly/core/utils/methods/map.dart';

class DashboardProductModel extends Equatable {
  final String productId;
  final String name;
  final String brandName;
  final double price;
  final String imageUrl;
  final String barCode;
  final DateTime? mfgDate;
  final DateTime? expiryDate;
  final String batchNo;
  final int totalQuantity;
  final int availableQuantity;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DashboardProductModel({
    required this.productId,
    required this.name,
    required this.brandName,
    required this.price,
    required this.imageUrl,
    required this.barCode,
    required this.batchNo,
    required this.totalQuantity,
    required this.availableQuantity,
    this.mfgDate,
    this.expiryDate,
    this.createdAt,
    this.updatedAt,
  });

  // ── Serialization ──────────────────────────────────────────────────────────

  factory DashboardProductModel.fromJson(Map<String, dynamic> map) {
    return DashboardProductModel(
      productId: map.getString('product_id'),
      name: map.getString('name'),
      brandName: map.getString('brand_name'),
      price: double.tryParse(map.getString('price')) ?? 0.0,
      imageUrl: map.getString('image_url'),
      barCode: map.getString('bar_code'),
      batchNo: map.getString('batch_no'),
      totalQuantity: map.getInt('total_quantity'),
      availableQuantity: map.getInt('available_quantity'),
      mfgDate: DateTime.tryParse(map.getString('mfg_date')),
      expiryDate: DateTime.tryParse(map.getString('expiry_date')),
      createdAt: DateTime.tryParse(map.getString('created_at')),
      updatedAt: DateTime.tryParse(map.getString('updated_at')),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'brand_name': brandName,
      'price': price.toStringAsFixed(2),
      'image_url': imageUrl,
      'bar_code': barCode,
      'batch_no': batchNo,
      'total_quantity': totalQuantity,
      'available_quantity': availableQuantity,
      if (mfgDate != null) 'mfg_date': mfgDate!.toIso8601String(),
      if (expiryDate != null) 'expiry_date': expiryDate!.toIso8601String(),
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  // ── Mutation ───────────────────────────────────────────────────────────────

  DashboardProductModel copyWith({
    String? productId,
    String? name,
    String? brandName,
    double? price,
    String? imageUrl,
    String? barCode,
    String? batchNo,
    int? totalQuantity,
    int? availableQuantity,
    DateTime? mfgDate,
    DateTime? expiryDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DashboardProductModel(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      brandName: brandName ?? this.brandName,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      barCode: barCode ?? this.barCode,
      batchNo: batchNo ?? this.batchNo,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      mfgDate: mfgDate ?? this.mfgDate,
      expiryDate: expiryDate ?? this.expiryDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ── Equatable ──────────────────────────────────────────────────────────────

  @override
  List<Object?> get props => [
        productId,
        name,
        brandName,
        price,
        imageUrl,
        barCode,
        batchNo,
        totalQuantity,
        availableQuantity,
        mfgDate,
        expiryDate,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() => 'InventoryProduct(productId: $productId, name: $name)';
}