import 'package:equatable/equatable.dart';

enum ResetPasswordStatus { initial, submitting, success, failure }

class ResetPasswordState extends Equatable {
  const ResetPasswordState({
    this.password = '',
    this.confirmPassword = '',
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.status = ResetPasswordStatus.initial,
    this.errorMessage,
  });

  final String password;
  final String confirmPassword;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final ResetPasswordStatus status;
  final String? errorMessage;

  bool get isFormValid => password.length >= 6 && password == confirmPassword;

  ResetPasswordState copyWith({
    String? password,
    String? confirmPassword,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    ResetPasswordStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ResetPasswordState(
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        password,
        confirmPassword,
        obscurePassword,
        obscureConfirmPassword,
        status,
        errorMessage,
      ];
}
