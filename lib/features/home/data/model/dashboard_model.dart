import 'package:equatable/equatable.dart';
import 'package:orderly/core/utils/methods/map.dart';
import 'package:orderly/features/home/data/model/dashboard_product_model.dart';


class DashboardResponseModel extends Equatable {
  final int statusCode;
  final bool success;
  final String message;
  final List<DashboardProductModel> data;

  const DashboardResponseModel({
    required this.statusCode,
    required this.success,
    required this.message,
    required this.data,
  });

  factory DashboardResponseModel.fromJson(Map<String, dynamic> map) {
    return DashboardResponseModel(
      statusCode: map.getInt('statusCode'),
      success: map.getBool('success'),
      message: map.getString('message'),
      data: (map['data'] as List<dynamic>? ?? [])
          .map((e) => DashboardProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }

  

  DashboardResponseModel copyWith({
    int? statusCode,
    bool? success,
    String? message,
    List<DashboardProductModel>? data,
  }) {
    return DashboardResponseModel(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }



  @override
  List<Object?> get props => [statusCode, success, message, data];
}