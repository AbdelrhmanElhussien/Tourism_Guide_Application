import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tourist_app/core/exceptions/app_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourist_app/domain/entities/reqeuest/login/login_request.dart';
import 'package:tourist_app/domain/use_cases/loginInUseCase.dart';
import 'package:tourist_app/features/auth/cubit/auth_states.dart';

@injectable
class Loginviewmodel extends Cubit<AuthState> {
  final LoginInUseCase _loginInUseCase;
  Loginviewmodel(this._loginInUseCase) : super(AuthLoadingState());

  Future<void> login({required String email, required String password}) async {
    try {
      emit(AuthLoadingState());
      LoginRequest loginRequest = LoginRequest(
        email: email,
        password: password,
      );
      var authResponse = await _loginInUseCase.invoke(loginRequest);
      if (authResponse.token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userToken', authResponse.token!);
      }
      emit(AuthSuccessState(authResponse: authResponse));
    } on DioException catch (e) {
      String msg = (e.error is AppException) ? (e.error as AppException).message : 'UnExpected Error';
      emit(AuthErrorState(errorMsg: ServerException(message: msg)));
    } on AppException catch (e) {
      emit(AuthErrorState(errorMsg: ServerException(message: e.message)));
    } catch (e) {
      emit(AuthErrorState(errorMsg: UnexcpectedException(message: e.toString())));
    }
  }
}
