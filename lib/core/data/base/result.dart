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
    try {
      if (exception.actualException is DioException) {
        final error = exception.actualException as DioException;
        final response = error.response?.data as ApiErrorResponse?;
        return switch (response?.errorId) {
          'NotFound' => errorNotFound,
          _ => errorNotDefined,
        };
      }
    } catch (e) {
      return errorNotDefined;
    }
    return errorNotDefined;
  }

  String? get errorMessage {
    final actualException = exception.actualException;
    return (actualException as DioException).response?.data.toString();
  }
}
