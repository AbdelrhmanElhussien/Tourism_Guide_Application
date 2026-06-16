import 'package:json_annotation/json_annotation.dart';

part 'UserDto.g.dart';
@JsonSerializable()
class UserDto {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "userName")
  final String? userName;
  @JsonKey(name: "username")
  final String? username;
  @JsonKey(name: "fullName")
  final String? fullName;
  @JsonKey(name: "fullname")
  final String? fullname;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "role")
  final String? role;

  UserDto ({
    this.name,
    this.userName,
    this.username,
    this.fullName,
    this.fullname,
    this.email,
    this.role,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String? ?? json['Name'] as String?;
    final userName = json['userName'] as String? ?? json['UserName'] as String? ?? json['username'] as String? ?? json['Username'] as String?;
    final username = json['username'] as String? ?? json['Username'] as String? ?? json['userName'] as String? ?? json['UserName'] as String?;
    final fullName = json['fullName'] as String? ?? json['FullName'] as String? ?? json['fullname'] as String? ?? json['Fullname'] as String?;
    final fullname = json['fullname'] as String? ?? json['Fullname'] as String? ?? json['fullName'] as String? ?? json['FullName'] as String?;
    final email = json['email'] as String? ?? json['Email'] as String?;
    final role = json['role'] as String? ?? json['Role'] as String?;
    return UserDto(
      name: name,
      userName: userName,
      username: username,
      fullName: fullName,
      fullname: fullname,
      email: email,
      role: role,
    );
  }

  Map<String, dynamic> toJson() {
    return _$UserDtoToJson(this);
  }
}