import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class User {
  final String? name;
  final String? email;
  final String? role;

  User ({
    this.name,
    this.email,
    this.role,
  });

}