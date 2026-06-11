import 'package:tourist_app/api/model/response/auth/UserDto.dart';
import 'package:tourist_app/domain/entities/response/auth/User.dart';

extension UserMapper on UserDto{
 User toUser (){
   return User(name: name,email: email);
 }
}