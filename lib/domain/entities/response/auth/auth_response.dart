import 'package:json_annotation/json_annotation.dart';

//todo: pure classes
@JsonSerializable()
class Auth_response {
  final String? message;
  final String? token;
  final String? email;
  final String? userName;
  final String? role;

  Auth_response({
    this.message,
    this.token,
    this.email,
    this.userName,
    this.role,
  });
}
