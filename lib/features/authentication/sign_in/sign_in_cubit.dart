import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/body/authentication/sign_in/sign_in_body.dart';
import '../../../core/data/base/result.dart';
import '../data/repository/authentication_repository.dart';
import 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({required AuthenticationRepository authenticationRepository})
    : _authenticationRepository = authenticationRepository,
      super(const SignInState());

  final AuthenticationRepository _authenticationRepository;

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
          errorMessage: 'Enter a valid email and a password of 6+ characters.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: SignInStatus.submitting, clearError: true));

    final result = await _authenticationRepository.signIn(
      body: SignInBody(email: state.email.trim(), password: state.password),
    );

    switch (result) {
      case Success():
        emit(state.copyWith(status: SignInStatus.success));
      case Failed():
        emit(
          state.copyWith(
            status: SignInStatus.failure,
            errorMessage: 'Incorrect email or password.',
          ),
        );
    }
  }
}
