import 'package:dio/dio.dart';

import 'api_error_response.dart';

const errorNotDefined = 1000;
const errorNotFound = 999;

sealed class Result<T> {
  Result._();

  factory Result.success(T value) => Success(value);

  factory Result.failed(UseCaseException exception) => Failed(exception);
}

class Success<T> extends Result<T> {
  Success(this.value) : super._();
  final T value;
}

class UseCaseException implements Exception {
  UseCaseException(this.actualException);

  final dynamic actualException;
}

class Failed<T> extends Result<T> {
  Failed(this.exception) : super._();
  final UseCaseException exception;

  int get errorCode {
    final response = _apiErrorResponse;
    return switch (response?.statusCode) {
      404 => errorNotFound,
      _ => errorNotDefined,
    };
  }

  String? get errorMessage {
    final response = _apiErrorResponse;
    if (response != null) return response.message;

    final actualException = exception.actualException;
    if (actualException is DioException) {
      return actualException.message;
    }
    return actualException?.toString();
  }

  ApiErrorResponse? get _apiErrorResponse {
    final actualException = exception.actualException;
    if (actualException is! DioException) return null;

    final data = actualException.response?.data;
    if (data is ApiErrorResponse) return data;
    if (data is Map<String, dynamic>) {
      try {
        return ApiErrorResponse.fromJson(data);
      } on Object {
        return null;
      }
    }
    return null;
  }
}
