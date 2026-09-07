import 'package:flutter_bloc/flutter_bloc.dart';

import 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(const SignUpState());

  void fullNameChanged(String value) => _update(fullName: value);

  void emailChanged(String value) => _update(email: value);

  void passwordChanged(String value) => _update(password: value);

  void confirmPasswordChanged(String value) => _update(confirmPassword: value);

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

    // TODO: Thay phần mô phỏng này bằng AuthenticationRepository.
    await Future<void>.delayed(const Duration(milliseconds: 700));
    emit(state.copyWith(status: SignUpStatus.success));
  }

  String _validationMessage() {
    if (state.fullName.trim().length < 2) return 'Vui lòng nhập họ và tên.';
    if (!state.isEmailValid) return 'Email không hợp lệ.';
    if (state.password.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự.';
    }
    if (state.password != state.confirmPassword) {
      return 'Mật khẩu xác nhận không khớp.';
    }
    if (!state.acceptTerms) return 'Bạn cần đồng ý với điều khoản sử dụng.';
    return 'Thông tin đăng ký chưa hợp lệ.';
  }
}
