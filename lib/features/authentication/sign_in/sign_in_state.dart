import 'package:equatable/equatable.dart';

enum SignInStatus { initial, submitting, success, failure }

class SignInState extends Equatable {
  const SignInState({
    this.email = '',
    this.password = '',
    this.obscurePassword = true,
    this.rememberMe = false,
    this.status = SignInStatus.initial,
    this.errorMessage,
  });

  final String email;
  final String password;
  final bool obscurePassword;
  final bool rememberMe;
  final SignInStatus status;
  final String? errorMessage;

  bool get isEmailValid =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email.trim());

  bool get isPasswordValid => password.length >= 6;

  bool get isFormValid => isEmailValid && isPasswordValid;

  SignInState copyWith({
    String? email,
    String? password,
    bool? obscurePassword,
    bool? rememberMe,
    SignInStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      rememberMe: rememberMe ?? this.rememberMe,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        obscurePassword,
        rememberMe,
        status,
        errorMessage,
      ];
}
