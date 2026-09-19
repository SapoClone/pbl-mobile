import 'package:json_annotation/json_annotation.dart';

part 'api_error_response.g.dart';

@JsonSerializable(createToJson: false)
class ApiErrorResponse {
  const ApiErrorResponse({
    required this.timestamp,
    required this.statusCode,
    required this.error,
    required this.errorCode,
    required this.message,
    this.details = const [],
  });

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorResponseFromJson(json);

  final String timestamp;
  final int statusCode;
  final String error;
  final String errorCode;
  final String message;
  final List<ApiErrorDetail> details;

  @override
  String toString() {
    return message;
  }
}

@JsonSerializable(createToJson: false)
class ApiErrorDetail {
  const ApiErrorDetail({
    required this.property,
    required this.code,
    required this.message,
  });

  factory ApiErrorDetail.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorDetailFromJson(json);

  final String property;
  final String code;
  final String message;
}
