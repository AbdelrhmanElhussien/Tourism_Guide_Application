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
    final token = json['token'] as String? ?? json['Token'] as String?;
    final message = json['message'] as String? ?? json['Message'] as String?;
    return TokensDto(
      token: token,
      message: message,
    );
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
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json['Data'] is Map<String, dynamic>
            ? json['Data'] as Map<String, dynamic>
            : json;

    final email = data['email'] as String? ?? data['Email'] as String?;
    final userName = data['userName'] as String? ??
        data['UserName'] as String? ??
        data['username'] as String? ??
        data['Username'] as String?;
    final role = data['role'] as String? ?? data['Role'] as String?;
    
    TokensDto? tokens;
    final tokensVal = data['tokens'] ?? data['Tokens'];
    if (tokensVal != null && tokensVal is Map<String, dynamic>) {
      tokens = TokensDto.fromJson(tokensVal);
    } else {
      final directToken = data['token'] as String? ??
          data['Token'] as String? ??
          data['token_key'] as String?;
      if (directToken != null) {
        tokens = TokensDto(
          token: directToken,
          message: data['message'] as String? ?? data['Message'] as String?,
        );
      }
    }
    return Auth_response_dto(
      tokens: tokens,
      email: email,
      userName: userName,
      role: role,
    );
  }

  Map<String, dynamic> toJson() {
    return _$Auth_response_dtoToJson(this);
  }
}
