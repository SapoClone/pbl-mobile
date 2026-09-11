import 'package:equatable/equatable.dart';

enum SignUpStatus { initial, submitting, success, failure }

class SignUpState extends Equatable {
  const SignUpState({
    this.fullName = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.acceptTerms = false,
    this.status = SignUpStatus.initial,
    this.errorMessage,
  });

  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool acceptTerms;
  final SignUpStatus status;
  final String? errorMessage;

  bool get isEmailValid =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email.trim());

  bool get isFormValid =>
      fullName.trim().length >= 2 &&
      isEmailValid &&
      password.length >= 6 &&
      password == confirmPassword &&
      acceptTerms;

  SignUpState copyWith({
    String? fullName,
    String? email,
    String? password,
    String? confirmPassword,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    bool? acceptTerms,
    SignUpStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SignUpState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
      acceptTerms: acceptTerms ?? this.acceptTerms,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        email,
        password,
        confirmPassword,
        obscurePassword,
        obscureConfirmPassword,
        acceptTerms,
        status,
        errorMessage,
      ];
}
