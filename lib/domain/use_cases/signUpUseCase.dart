import 'package:injectable/injectable.dart';
import 'package:tourist_app/domain/entities/reqeuest/register/register_request.dart';
import 'package:tourist_app/domain/entities/response/auth/auth_response.dart';
import 'package:tourist_app/domain/repositories/auth/authRepoContract.dart';
@injectable
class  SignUpUseCase {
  final AuthRepoContract _authRepoContract;
  SignUpUseCase(this._authRepoContract);
  Future<Auth_response> invoke(RegisterRequest registerRequest){
    return _authRepoContract.signUp(registerRequest);
  }
}