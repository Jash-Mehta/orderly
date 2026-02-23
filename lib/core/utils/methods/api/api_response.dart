/// Generic wrapper that matches your server's response envelope:
/// {
///   "statusCode": 200,
///   "success": true,
///   "message": "...",
///   "data": { ... } or [ ... ] or null
/// }
class ApiResponse<T> {
  final int statusCode;
  final bool success;
  final String message;
  final T data;

  const ApiResponse({
    required this.statusCode,
    required this.success,
    required this.message,
    required this.data,
  });

  /// For responses where `data` is a JSON object → Map
  ///
  /// Example:
  ///   ApiResponse.fromJson(json, LoginResponse.fromJson)
  ///   ApiResponse.fromJson(json, User.fromJson)
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromData,
  ) {
    return ApiResponse(
      statusCode: json['statusCode'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: fromData(json['data'] as Map<String, dynamic>),
    );
  }

  /// For responses where `data` is a JSON array → List
  ///
  /// Example:
  ///   ApiResponse.fromJsonList(json, Order.fromJson)
  ///   ApiResponse.fromJsonList(json, Product.fromJson)
  factory ApiResponse.fromJsonList(
    Map<String, dynamic> json,
    T Function(List<Map<String, dynamic>>) fromData,
  ) {
    return ApiResponse(
      statusCode: json['statusCode'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: fromData(
        (json['data'] as List).cast<Map<String, dynamic>>(),
      ),
    );
  }

  /// For responses where `data` is null or irrelevant (e.g. logout, delete).
  ///
  /// Example:
  ///   ApiResponse.fromEmpty(json)
  factory ApiResponse.fromEmpty(Map<String, dynamic> json) {
    return ApiResponse(
      statusCode: json['statusCode'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: null as T,
    );
  }

  @override
  String toString() =>
      'ApiResponse(statusCode: $statusCode, success: $success, message: $message)';
}