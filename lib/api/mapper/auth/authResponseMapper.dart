import 'package:tourist_app/api/mapper/auth/user_mapper.dart';
import 'package:tourist_app/api/model/response/auth/auth_response_dto.dart';
import 'package:tourist_app/domain/entities/response/auth/auth_response.dart';

extension AuthResponseMapper on Auth_response_dto {
  Auth_response toAuthResponse() {
    return Auth_response(message: message, token: token, user: user?.toUser());
  }
}
