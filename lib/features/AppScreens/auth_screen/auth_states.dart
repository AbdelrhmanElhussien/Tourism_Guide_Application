import 'dart:ui';

import 'package:tourist_app/core/exceptions/app_exception.dart';
import 'package:tourist_app/domain/entities/response/auth/auth_response.dart';

sealed class AuthState {}//todo : seald => closed class does not mke about it object on inharet it
class AuthLoadingState extends AuthState{}
class AuthErrorState extends AuthState{
  AppException errorMsg;
  AuthErrorState({required this.errorMsg});
}
class AuthSuccessState extends AuthState{
  Auth_response authResponse;
  AuthSuccessState({required this.authResponse});
}
