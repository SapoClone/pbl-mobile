import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

const String headerContentType = 'Content-Type';
const String defaultContentType = 'application/json; charset=utf-8';

@Singleton()
class DioProvider {
  DioProvider();

  Dio? _dio;

  Dio getDio() {
    _dio ??= _createDio();
    return _dio!;
  }

  Dio _createDio() {
    final dio = Dio();

    final interceptors = <Interceptor>[];

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

    return dio
      ..options.connectTimeout = const Duration(seconds: 20)
      ..options.receiveTimeout = const Duration(seconds: 20)
      ..options.headers = {headerContentType: defaultContentType}
      ..options = BaseOptions(
        headers: {
          HttpHeaders.cacheControlHeader: 'no-cache',
          HttpHeaders.acceptEncodingHeader: 'gzip, deflate',
          HttpHeaders.connectionHeader: 'keep-alive',
          HttpHeaders.acceptHeader: 'application/json',
        },
      )
      ..interceptors.addAll(interceptors);
  }
}
