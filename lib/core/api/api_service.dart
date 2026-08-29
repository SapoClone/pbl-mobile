import 'package:dio/dio.dart' hide Headers;
import 'body/authentication/sign_in/sign_in_body.dart';
import 'response/authentication/sign_in/sign_in_response.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST('/api/website/v1/auth/signin')
  Future<SignInResponse> signIn({
    @Body() required SignInBody body,
  });
}
