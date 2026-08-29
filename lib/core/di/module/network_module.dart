import 'package:injectable/injectable.dart';
import '../../api/api_service.dart';
import '../../dio/dio_provider.dart';
import '../../../env.dart';

@module
abstract class NetworkModule {
  @singleton
  ApiService provideApiService(DioProvider dioProvider) {
    return ApiService(
      dioProvider.getDio(),
      baseUrl: Env.restApiEndpoint,
    );
  }
}
