import 'package:injectable/injectable.dart';

import '../../../../core/api/api_service.dart';
import '../../../../core/api/body/authentication/sign_in/sign_in_body.dart';
import '../../../../core/api/response/authentication/sign_in/sign_in_response.dart';
import '../../../../core/data/base/result.dart';

/// TODO: This repository is for template purpose
///
abstract class AuthenticationRepository {
  Future<Result<SignInResponse>> signIn({
    required SignInBody body,
  });
}

@Singleton(as: AuthenticationRepository)
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl({required ApiService apiService})
      : _apiService = apiService;

  final ApiService _apiService;

  @override
  Future<Result<SignInResponse>> signIn({
    required SignInBody body,
  }) async {
    try {
      final result = await _apiService.signIn(body: body);
      return Result.success(result);
    } catch (e) {
      return Result.failed(UseCaseException(e));
    }
  }
}
