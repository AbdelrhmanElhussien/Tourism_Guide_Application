
import 'package:tourist_app/api/model/request/login/login_request_dto.dart';
import 'package:tourist_app/domain/entities/reqeuest/login/login_request.dart';

extension LoginRequestMapper on LoginRequest{
  LoginRequestDto toLoginReqeustDto() {
    return LoginRequestDto(
        email: email,
        password: password
    );
  }

}