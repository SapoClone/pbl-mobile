import 'package:json_annotation/json_annotation.dart';

part 'api_error_response.g.dart';

@JsonSerializable(createToJson: false)
class ApiErrorResponse {
  ApiErrorResponse({
    this.success = false,
    required this.message,
    required this.errorId,
    this.errors = const [],
  });

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorResponseFromJson(json);

  final bool success;
  final String message;
  final String errorId;
  final List<String> errors;

  @override
  String toString() {
    return message;
  }
}
