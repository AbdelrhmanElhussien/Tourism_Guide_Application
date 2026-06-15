import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tourist_app/core/exceptions/app_exception.dart';
import 'package:tourist_app/domain/entities/reqeuest/register/register_request.dart';
import 'package:tourist_app/domain/use_cases/signUpUseCase.dart';
import 'package:tourist_app/features/auth/cubit/auth_states.dart';

@injectable
class RegisetrViewModel extends Cubit<AuthState> {
  final SignUpUseCase _signUpUseCase;
  RegisetrViewModel(this._signUpUseCase) : super(AuthLoadingState());

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String confirmPassword,
    required String phoneNumber,
    required String nationality,
  }) async {
    try {
      emit(AuthLoadingState());

      RegisterRequest registerRequest = RegisterRequest(
        password: password,
        email: email,
        fullName: fullName,
        confirmPassword: confirmPassword,
        phoneNumber: phoneNumber,
        nationality: nationality,
      );
      var authResponse = await _signUpUseCase.invoke(registerRequest);
      emit(AuthSuccessState(authResponse: authResponse));
    } on DioException catch (e) {
      String msg = (e.error is AppException)
          ? (e.error as AppException).message
          : 'UnExpected Error';
      emit(AuthErrorState(errorMsg: ServerException(message: msg)));
    } on AppException catch (e) {
      emit(AuthErrorState(errorMsg: ServerException(message: e.message)));
    } catch (e) {
      emit(
        AuthErrorState(errorMsg: UnexcpectedException(message: e.toString())),
      );
    }
  }
}
