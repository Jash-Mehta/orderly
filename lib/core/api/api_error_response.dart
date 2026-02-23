class ApiErrorResponse {
  final int statusCode;
  final bool success;
  final String message;
  final ApiErrorDetail? error;

  const ApiErrorResponse({
    required this.statusCode,
    required this.success,
    required this.message,
    this.error,
  });

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    return ApiErrorResponse(
      statusCode: json['statusCode'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      error: json['error'] != null
          ? ApiErrorDetail.fromJson(json['error'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Human-readable message — prefers `error.details` over top-level `message`
  /// since details is more specific.
  String get displayMessage => error?.details ?? message;

  @override
  String toString() =>
      'ApiErrorResponse(statusCode: $statusCode, message: $message, code: ${error?.code})';
}

class ApiErrorDetail {
  final String code;
  final String details;

  const ApiErrorDetail({
    required this.code,
    required this.details,
  });

  factory ApiErrorDetail.fromJson(Map<String, dynamic> json) {
    return ApiErrorDetail(
      code: json['code'] as String,
      details: json['details'] as String,
    );
  }
}