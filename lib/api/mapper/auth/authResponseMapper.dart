import 'package:tourist_app/api/model/response/auth/auth_response_dto.dart';
import 'package:tourist_app/domain/entities/response/auth/auth_response.dart';

extension AuthResponseMapper on Auth_response_dto {
  Auth_response toAuthResponse() {
    return Auth_response(
      message: tokens?.message,
      token: tokens?.token,
      email: email,
      userName: userName,
      role: role,
    );
  }
}
