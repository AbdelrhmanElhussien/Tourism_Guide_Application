import 'package:json_annotation/json_annotation.dart';

part 'auth_response_dto.g.dart';

@JsonSerializable()
class TokensDto {
  @JsonKey(name: "token")
  final String? token;
  @JsonKey(name: "message")
  final String? message;

  TokensDto({
    this.token,
    this.message,
  });

  factory TokensDto.fromJson(Map<String, dynamic> json) {
    return _$TokensDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$TokensDtoToJson(this);
  }
}

@JsonSerializable()
class Auth_response_dto {
  @JsonKey(name: "tokens")
  final TokensDto? tokens;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "userName")
  final String? userName;
  @JsonKey(name: "role")
  final String? role;

  Auth_response_dto({
    this.tokens,
    this.email,
    this.userName,
    this.role,
  });

  factory Auth_response_dto.fromJson(Map<String, dynamic> json) {
    return _$Auth_response_dtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$Auth_response_dtoToJson(this);
  }
}
