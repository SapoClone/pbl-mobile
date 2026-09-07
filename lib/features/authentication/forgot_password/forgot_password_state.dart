import 'package:equatable/equatable.dart';

enum ForgotPasswordStatus { initial, submitting, success, failure }

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.email = '',
    this.status = ForgotPasswordStatus.initial,
    this.errorMessage,
  });

  final String email;
  final ForgotPasswordStatus status;
  final String? errorMessage;

  bool get isEmailValid =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email.trim());

  ForgotPasswordState copyWith({
    String? email,
    ForgotPasswordStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, status, errorMessage];
}
