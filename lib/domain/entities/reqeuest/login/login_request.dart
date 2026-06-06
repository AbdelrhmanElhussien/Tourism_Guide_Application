import 'package:json_annotation/json_annotation.dart';
import 'package:tourist_app/api/model/request/login/login_request_dto.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {

  final String? email;
  final String? password;

  LoginRequest ({
    this.email,
    this.password,
  });


}


