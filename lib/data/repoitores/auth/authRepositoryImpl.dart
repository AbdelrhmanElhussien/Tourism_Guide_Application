import 'package:injectable/injectable.dart';
import 'package:tourist_app/data/data_sources/remot/auth/authRemoteDataSource.dart';
import 'package:tourist_app/domain/entities/reqeuest/login/login_request.dart';
import 'package:tourist_app/domain/entities/reqeuest/register/register_request.dart';
import 'package:tourist_app/domain/entities/response/auth/auth_response.dart';
import 'package:tourist_app/domain/repositories/auth/authRepoContract.dart';

@Injectable(as:AuthRepoContract)
class Authrepositoryimpl implements AuthRepoContract{
  Authremotedatasource _authremotedatasource;
  Authrepositoryimpl(this._authremotedatasource);
  @override
  Future<Auth_response> login(LoginRequest loginRequest) {
   return _authremotedatasource.login(loginRequest);
  }

  @override
  Future<Auth_response> signUp(RegisterRequest registerRequest) {
   return _authremotedatasource.signUp(registerRequest);
  }
  
}