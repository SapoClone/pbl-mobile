import 'package:json_annotation/json_annotation.dart';

part 'register_body.g.dart';

@JsonSerializable(checked: true, createFactory: false)
class RegisterBody {
  const RegisterBody({required this.email, required this.password});

  final String email;
  final String password;

  Map<String, dynamic> toJson() => _$RegisterBodyToJson(this);
}
