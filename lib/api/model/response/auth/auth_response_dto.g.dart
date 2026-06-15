// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokensDto _$TokensDtoFromJson(Map<String, dynamic> json) => TokensDto(
  token: json['token'] as String?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$TokensDtoToJson(TokensDto instance) => <String, dynamic>{
  'token': instance.token,
  'message': instance.message,
};

Auth_response_dto _$Auth_response_dtoFromJson(Map<String, dynamic> json) =>
    Auth_response_dto(
      tokens: json['tokens'] == null
          ? null
          : TokensDto.fromJson(json['tokens'] as Map<String, dynamic>),
      email: json['email'] as String?,
      userName: json['userName'] as String?,
      role: json['role'] as String?,
    );

Map<String, dynamic> _$Auth_response_dtoToJson(Auth_response_dto instance) =>
    <String, dynamic>{
      'tokens': instance.tokens,
      'email': instance.email,
      'userName': instance.userName,
      'role': instance.role,
    };
