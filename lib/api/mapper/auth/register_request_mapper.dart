

import 'package:tourist_app/api/model/request/register/register_request_dto.dart';
import 'package:tourist_app/domain/entities/reqeuest/register/register_request.dart';

extension RegisterRequestMapper on RegisterRequest{
 RegisterRequestDto toRegisterRequestDto(){
   return RegisterRequestDto(
       password: password,
       email:email ,
       name: name,
       phone:phone ,
       rePassword: rePassword
   );
 }

}