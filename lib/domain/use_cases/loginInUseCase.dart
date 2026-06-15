import 'package:injectable/injectable.dart';
import 'package:tourist_app/domain/entities/reqeuest/login/login_request.dart';
import 'package:tourist_app/domain/entities/response/auth/auth_response.dart';
import 'package:tourist_app/domain/repositories/auth/authRepoContract.dart';
@injectable
class LoginInUseCase {
  final AuthRepoContract _authRepoContract;
  LoginInUseCase(this._authRepoContract);
  Future<Auth_response> invoke(LoginRequest loginRequest) {
   return _authRepoContract.login(loginRequest);
  }
}
