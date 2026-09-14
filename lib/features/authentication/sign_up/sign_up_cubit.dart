import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/body/authentication/register/register_body.dart';
import '../../../core/data/base/result.dart';
import '../data/repository/authentication_repository.dart';
import 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({required AuthenticationRepository authenticationRepository})
    : _authenticationRepository = authenticationRepository,
      super(const SignUpState());

  final AuthenticationRepository _authenticationRepository;

  void fullNameChanged(String value) => _update(fullName: value);

  void emailChanged(String value) => _update(email: value);

  void passwordChanged(String value) => _update(password: value);

  void confirmPasswordChanged(String value) => _update(confirmPassword: value);

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword));
  }

  void acceptTermsChanged(bool value) {
    emit(state.copyWith(acceptTerms: value, clearError: true));
  }

  void _update({
    String? fullName,
    String? email,
    String? password,
    String? confirmPassword,
  }) {
    emit(
      state.copyWith(
        fullName: fullName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        status: SignUpStatus.initial,
        clearError: true,
      ),
    );
  }

  Future<void> submit() async {
    if (!state.isFormValid || state.status == SignUpStatus.submitting) {
      emit(
        state.copyWith(
          status: SignUpStatus.failure,
          errorMessage: _validationMessage(),
        ),
      );
      return;
    }

    emit(state.copyWith(status: SignUpStatus.submitting, clearError: true));

    final result = await _authenticationRepository.register(
      body: RegisterBody(email: state.email.trim(), password: state.password),
    );

    switch (result) {
      case Success():
        emit(state.copyWith(status: SignUpStatus.success));
      case Failed(:final errorMessage):
        emit(
          state.copyWith(
            status: SignUpStatus.failure,
            errorMessage:
                errorMessage ?? 'Unable to create account. Please try again.',
          ),
        );
    }
  }

  String _validationMessage() {
    if (state.fullName.trim().length < 2) return 'Enter your full name.';
    if (!state.isEmailValid) return 'Enter a valid email address.';
    if (state.password.length < 6) {
      return 'Password must contain at least 6 characters.';
    }
    if (state.password != state.confirmPassword) {
      return 'Password confirmation does not match.';
    }
    if (!state.acceptTerms) return 'You must accept the Terms of Service.';
    return 'The registration details are invalid.';
  }
}
