import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {

  final String? name;

  final String? email;

  final String? password;

  final String? rePassword;

  final String? phone;

  RegisterRequest ({
    this.name,
    this.email,
    this.password,
    this.rePassword,
    this.phone,
  });


}


