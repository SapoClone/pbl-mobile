import 'package:flutter_bloc/flutter_bloc.dart';

import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit({required this.email}) : super(const ResetPasswordState());

  final String email;

  void passwordChanged(String value) {
    emit(
      state.copyWith(
        password: value,
        status: ResetPasswordStatus.initial,
        clearError: true,
      ),
    );
  }

  void confirmPasswordChanged(String value) {
    emit(
      state.copyWith(
        confirmPassword: value,
        status: ResetPasswordStatus.initial,
        clearError: true,
      ),
    );
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void toggleConfirmPasswordVisibility() {
    emit(
      state.copyWith(
        obscureConfirmPassword: !state.obscureConfirmPassword,
      ),
    );
  }

  Future<void> submit() async {
    if (state.status == ResetPasswordStatus.submitting) return;

    final errorMessage = _validationMessage();
    if (errorMessage != null) {
      emit(
        state.copyWith(
          status: ResetPasswordStatus.failure,
          errorMessage: errorMessage,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: ResetPasswordStatus.submitting,
        clearError: true,
      ),
    );

    // TODO: Gọi API đặt lại mật khẩu với email và mã xác thực.
    await Future<void>.delayed(const Duration(milliseconds: 700));
    emit(state.copyWith(status: ResetPasswordStatus.success));
  }

  String? _validationMessage() {
    if (state.password.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự.';
    }
    if (state.password != state.confirmPassword) {
      return 'Mật khẩu xác nhận không khớp.';
    }
    return null;
  }
}
