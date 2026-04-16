import 'package:artisan_hr/shared/core/errors/app_exception.dart';

class ApiResponse {
  const ApiResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.dataOrNull,
  });

  final bool success;
  final String message;
  final int statusCode;
  final Object? dataOrNull;

  factory ApiResponse.fromJson({
    required int statusCode,
    required Map<String, dynamic> json,
  }) {
    return ApiResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      statusCode: statusCode,
      dataOrNull: json['data'],
    );
  }

  Map<String, dynamic> requireDataMap() {
    final data = dataOrNull;
    if (data is Map<String, dynamic>) return data;
    throw const AppException('Expected a JSON object in the response data.');
  }
}
