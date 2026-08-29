import 'package:equatable/equatable.dart';

import '../../../../common/enums/loading_status.dart';

/// TODO: This state is for template purpose
///
class AuthenticationState extends Equatable {
  const AuthenticationState({
    this.loadingStatus = LoadingStatus.initial,
  });

  final LoadingStatus loadingStatus;

  AuthenticationState copyWith({
    LoadingStatus? loadingStatus,
  }) {
    return AuthenticationState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
    );
  }

  @override
  List<Object?> get props => [loadingStatus];
}
