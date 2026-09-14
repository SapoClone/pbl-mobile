import 'package:injectable/injectable.dart';

import '../../../../core/api/api_service.dart';
import '../../../../core/api/body/authentication/register/register_body.dart';
import '../../../../core/api/body/authentication/sign_in/sign_in_body.dart';
import '../../../../core/api/response/authentication/sign_in/sign_in_response.dart';
import '../../../../core/data/base/result.dart';
import '../../../../core/storage/storage_repository.dart';

/// TODO: This repository is for template purpose
///
abstract class AuthenticationRepository {
  Future<Result<SignInResponse>> signIn({required SignInBody body});

  Future<Result<void>> register({required RegisterBody body});

  Future<Result<void>> logout();
}

@Singleton(as: AuthenticationRepository)
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl({
    required ApiService apiService,
    required StorageRepository storageRepository,
  }) : _apiService = apiService,
       _storageRepository = storageRepository;

  final ApiService _apiService;
  final StorageRepository _storageRepository;

  @override
  Future<Result<SignInResponse>> signIn({required SignInBody body}) async {
    try {
      final result = await _apiService.signIn(body: body);
      await Future.wait([
        _storageRepository.storeAccessToken(result.accessToken),
        _storageRepository.storeRefreshToken(result.refreshToken),
      ]);
      return Result.success(result);
    } catch (e) {
      return Result.failed(UseCaseException(e));
    }
  }

  @override
  Future<Result<void>> register({required RegisterBody body}) async {
    try {
      await _apiService.register(body: body);
      return Result<void>.success(null);
    } catch (e) {
      return Result<void>.failed(UseCaseException(e));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _apiService.logout();
      return Result<void>.success(null);
    } catch (e) {
      return Result<void>.failed(UseCaseException(e));
    } finally {
      await _storageRepository.clearAllStorage();
    }
  }
}
