import 'package:tourist_app/core/exceptions/app_exception.dart';
import 'package:tourist_app/domain/entities/response/auth/auth_response.dart';

sealed class AuthState {}
class AuthLoadingState extends AuthState {}
class AuthErrorState extends AuthState {
  AppException errorMsg;
  AuthErrorState({required this.errorMsg});
}
class AuthSuccessState extends AuthState {
  Auth_response authResponse;
  AuthSuccessState({required this.authResponse});
}
