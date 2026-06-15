import 'package:json_annotation/json_annotation.dart';

part 'register_request_dto.g.dart';

@JsonSerializable()
class RegisterRequestDto {
  @JsonKey(name: "fullName")
  final String? fullName;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "phoneNumber")
  final String? phoneNumber;
  @JsonKey(name: "nationality")
  final String? nationality;
  @JsonKey(name: "password")
  final String? password;
  @JsonKey(name: "confirmPassword")
  final String? confirmPassword;

  RegisterRequestDto({
    this.fullName,
    this.email,
    this.phoneNumber,
    this.nationality,
    this.password,
    this.confirmPassword,
  });

  factory RegisterRequestDto.fromJson(Map<String, dynamic> json) {
    return _$RegisterRequestDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$RegisterRequestDtoToJson(this);
  }
}
