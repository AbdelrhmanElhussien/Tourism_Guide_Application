import 'package:tourist_app/domain/entities/reqeuest/login/login_request.dart';
import 'package:tourist_app/domain/entities/reqeuest/register/register_request.dart';
import 'package:tourist_app/domain/entities/response/auth/auth_response.dart';

abstract class AuthRepoContract {
  Future <Auth_response> login(LoginRequest loginRequest);
  Future <Auth_response> signUp(RegisterRequest registerRequest);

}