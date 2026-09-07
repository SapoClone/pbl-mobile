import 'package:flutter_bloc/flutter_bloc.dart';

import 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(const SignInState());

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: value,
        status: SignInStatus.initial,
        clearError: true,
      ),
    );
  }

  void passwordChanged(String value) {
    emit(
      state.copyWith(
        password: value,
        status: SignInStatus.initial,
        clearError: true,
      ),
    );
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void rememberMeChanged(bool value) {
    emit(state.copyWith(rememberMe: value));
  }

  Future<void> submit() async {
    if (!state.isFormValid || state.status == SignInStatus.submitting) {
      emit(
        state.copyWith(
          status: SignInStatus.failure,
          errorMessage: 'Vui lòng nhập email hợp lệ và mật khẩu từ 6 ký tự.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: SignInStatus.submitting, clearError: true));

    // TODO: Thay phần mô phỏng này bằng AuthenticationRepository.
    await Future<void>.delayed(const Duration(milliseconds: 700));
    emit(state.copyWith(status: SignInStatus.success));
  }
}
