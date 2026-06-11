import 'package:injectable/injectable.dart';
import 'package:tourist_app/api/api_services.dart';
import 'package:tourist_app/api/mapper/auth/authResponseMapper.dart';
import 'package:tourist_app/api/mapper/auth/login_request_mapper.dart';
import 'package:tourist_app/api/mapper/auth/register_request_mapper.dart';
import 'package:tourist_app/data/data_sources/remot/auth/authRemoteDataSource.dart';
import 'package:tourist_app/domain/entities/reqeuest/login/login_request.dart';
import 'package:tourist_app/domain/entities/reqeuest/register/register_request.dart';
import 'package:tourist_app/domain/entities/response/auth/auth_response.dart';

@Injectable(as:Authremotedatasource)

class AuthRemoteDatasrcImpl implements Authremotedatasource{

  ApiServices _apiServices;
  AuthRemoteDatasrcImpl(this._apiServices);

  @override
  Future<Auth_response> login(LoginRequest loginRequest)async {
    //todo:LoginRequest => LoginRequestDto
    var authResponse = await _apiServices.login(loginRequest.toLoginReqeustDto());
    //todo:AuthResponseDto => AuthResponse
    return authResponse.toAuthResponse();

  }

  @override
  Future<Auth_response> signUp(RegisterRequest registerRequest)async {
   var authResponse = await _apiServices.signUp(registerRequest.toRegisterRequestDto());
   return authResponse.toAuthResponse();
  }
  
}