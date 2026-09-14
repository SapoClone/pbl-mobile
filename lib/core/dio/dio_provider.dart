import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../storage/storage_repository.dart';
import 'auth_interceptor.dart';

const String headerContentType = 'Content-Type';
const String defaultContentType = 'application/json; charset=utf-8';

@Singleton()
class DioProvider {
  DioProvider();

  Dio? _dio;

  Dio getDio(StorageRepository storageRepository) {
    _dio ??= _createDio(storageRepository);
    return _dio!;
  }

  Dio _createDio(StorageRepository storageRepository) {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        contentType: defaultContentType,
        headers: {
          HttpHeaders.cacheControlHeader: 'no-cache',
          HttpHeaders.acceptEncodingHeader: 'gzip, deflate',
          HttpHeaders.connectionHeader: 'keep-alive',
          HttpHeaders.acceptHeader: 'application/json',
        },
      ),
    );

    final interceptors = <Interceptor>[AuthInterceptor(storageRepository)];

    if (!kReleaseMode) {
      interceptors.add(
        LogInterceptor(
          request: true,
          responseBody: true,
          requestBody: true,
          requestHeader: true,
        ),
      );
    }

    return dio..interceptors.addAll(interceptors);
  }
}
