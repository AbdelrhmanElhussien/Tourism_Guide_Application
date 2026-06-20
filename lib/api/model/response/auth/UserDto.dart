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
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json['Data'] is Map<String, dynamic>
            ? json['Data'] as Map<String, dynamic>
            : json;

    final name = data['name'] as String? ?? data['Name'] as String?;
    final userName = data['userName'] as String? ??
        data['UserName'] as String? ??
        data['username'] as String? ??
        data['Username'] as String?;
    final username = data['username'] as String? ??
        data['Username'] as String? ??
        data['userName'] as String? ??
        data['UserName'] as String?;
    final fullName = data['fullName'] as String? ??
        data['FullName'] as String? ??
        data['fullname'] as String? ??
        data['Fullname'] as String?;
    final fullname = data['fullname'] as String? ??
        data['Fullname'] as String? ??
        data['fullName'] as String? ??
        data['FullName'] as String?;
    final email = data['email'] as String? ?? data['Email'] as String?;
    final role = data['role'] as String? ?? data['Role'] as String?;
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
