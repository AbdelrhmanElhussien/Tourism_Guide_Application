import 'package:json_annotation/json_annotation.dart';
import 'package:tourist_app/api/model/response/auth/UserDto.dart';

part 'auth_response_dto.g.dart';

@JsonSerializable()
class Auth_response_dto {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "user")
  final UserDto? user;
  @JsonKey(name: "token")
  final String? token;

  Auth_response_dto ({
    this.message,
    this.user,
    this.token,
  });

  factory Auth_response_dto.fromJson(Map<String, dynamic> json) {
    return _$Auth_response_dtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$Auth_response_dtoToJson(this);
  }
}




