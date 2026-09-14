import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_body.g.dart';

@JsonSerializable(checked: true, createFactory: false)
class SignInBody {
  const SignInBody({required this.email, required this.password});

  final String email;
  final String password;

  Map<String, dynamic> toJson() => _$SignInBodyToJson(this);
}
