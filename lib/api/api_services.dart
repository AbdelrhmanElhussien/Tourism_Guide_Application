import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tourist_app/api/api_constant.dart';
import 'package:tourist_app/api/model/request/login/login_request_dto.dart';
import 'package:tourist_app/api/model/request/register/register_request_dto.dart';
import 'package:tourist_app/api/model/response/auth/auth_response_dto.dart';

part 'api_services.g.dart';

@RestApi()
abstract class ApiServices {
  factory ApiServices(Dio dio, {String? baseUrl}) = _ApiServices;

  @POST(ApiConstant.signInEndPoint)
  Future<Auth_response_dto> login(@Body() LoginRequestDto loginRequest);

  @POST(ApiConstant.signUpEndPoint)
  Future<Auth_response_dto> signUp(@Body() RegisterRequestDto registerRequest);
}
