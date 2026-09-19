import 'package:injectable/injectable.dart';
import '../../api/api_service.dart';
import '../../dio/dio_provider.dart';
import '../../storage/storage_repository.dart';
import '../../../env.dart';

@module
abstract class NetworkModule {
  @singleton
  ApiService provideApiService(
    DioProvider dioProvider,
    StorageRepository storageRepository,
  ) {
    return ApiService(
      dioProvider.getDio(storageRepository),
      baseUrl: Env.restApiEndpoint,
    );
  }
}
