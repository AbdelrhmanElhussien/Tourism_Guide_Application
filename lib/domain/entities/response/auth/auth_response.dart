import 'package:json_annotation/json_annotation.dart';
import 'package:tourist_app/domain/entities/response/auth/User.dart';

//todo: pure clases
@JsonSerializable()
class Auth_response {
  final String? message;
  final User? user;
  final String? token;

  Auth_response({
    this.message,
    this.user,
    this.token,
  });


}




