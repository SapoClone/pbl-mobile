import 'dart:io';

import 'package:dio/dio.dart';

import '../storage/storage_repository.dart';

const requiresAuthKey = 'requiresAuth';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storageRepository);

  final StorageRepository _storageRepository;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[requiresAuthKey] == false) {
      handler.next(options);
      return;
    }

    final accessToken = await _storageRepository.accessToken;
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
    }

    handler.next(options);
  }
}
