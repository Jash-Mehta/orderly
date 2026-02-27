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
  factory ApiResponse.fromJsonList(
    Map<String, dynamic> json,
    T Function(List<Map<String, dynamic>>) fromData,
  ) {
    return ApiResponse(
      statusCode: json['statusCode'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: fromData(
        (json['data'] as List).map((item) => item as Map<String, dynamic>).toList(),
      ),
    );
  }

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