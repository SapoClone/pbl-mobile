import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/enums/loading_status.dart';
import '../../../../core/api/body/authentication/sign_in/sign_in_body.dart';
import '../../../../core/di/di.dart';
import '../repository/authentication_repository.dart';
import '../state/authentication_state.dart';

/// TODO: This notifier is for template purpose
///
final counterNotifierProvider =
    NotifierProvider<AuthenticationNotifier, AuthenticationState>(
  () => AuthenticationNotifier(getIt.get<AuthenticationRepository>()),
);

class AuthenticationNotifier extends Notifier<AuthenticationState> {
  AuthenticationNotifier(this._authenticationRepository);
  final AuthenticationRepository _authenticationRepository;

  Future<void> signIn() async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    await _authenticationRepository.signIn(
      body: SignInBody(email: 'email', password: 'password'),
    );
    state = state.copyWith(loadingStatus: LoadingStatus.done);
  }

  @override
  AuthenticationState build() => AuthenticationState();
}
