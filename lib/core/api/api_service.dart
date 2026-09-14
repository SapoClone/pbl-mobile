import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import 'api_endpoints.dart';
import 'body/authentication/register/register_body.dart';
import 'body/authentication/sign_in/sign_in_body.dart';
import 'response/authentication/sign_in/sign_in_response.dart';
import '../dio/auth_interceptor.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  // Add future endpoints here using Retrofit's @GET, @POST, @PUT, @PATCH,
  // or @DELETE annotation. build_runner generates the Dio implementation.
  @Extra({requiresAuthKey: false})
  @POST(ApiEndpoints.signIn)
  Future<SignInResponse> signIn({@Body() required SignInBody body});

  @Extra({requiresAuthKey: false})
  @POST(ApiEndpoints.register)
  Future<void> register({@Body() required RegisterBody body});

  @POST(ApiEndpoints.logout)
  Future<void> logout();
}
