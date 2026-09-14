import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_response.g.dart';

@JsonSerializable(createToJson: true, explicitToJson: true)
class SignInResponse {
  const SignInResponse({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenExpires,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) =>
      _$SignInResponseFromJson(json);

  final String userId;
  final String accessToken;
  final String refreshToken;
  final int tokenExpires;

  Map<String, dynamic> toJson() => _$SignInResponseToJson(this);
}
