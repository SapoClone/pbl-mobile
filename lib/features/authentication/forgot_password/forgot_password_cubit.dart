import 'package:flutter_bloc/flutter_bloc.dart';

import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(const ForgotPasswordState());

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: value,
        status: ForgotPasswordStatus.initial,
        clearError: true,
      ),
    );
  }

  void submit() {
    if (state.status == ForgotPasswordStatus.submitting) return;

    emit(
      state.copyWith(
        status: ForgotPasswordStatus.success,
        clearError: true,
      ),
    );
  }
}
