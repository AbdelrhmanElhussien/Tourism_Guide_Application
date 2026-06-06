import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tourist_app/core/exceptions/app_exception.dart';
import 'package:tourist_app/domain/entities/reqeuest/login/login_request.dart';
import 'package:tourist_app/domain/entities/reqeuest/register/register_request.dart';
import 'package:tourist_app/domain/use_cases/loginInUseCase.dart';
import 'package:tourist_app/domain/use_cases/signUpUseCase.dart';
import 'package:tourist_app/features/AppScreens/auth_screen/auth_states.dart';

@injectable
class RegisetrViewModel extends Cubit<AuthState> {
  final SignUpUseCase _signUpUseCase;
  RegisetrViewModel(this._signUpUseCase) : super(AuthLoadingState());

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String rePassword,
    required String phone,
  }) async {
    try {
      emit(AuthLoadingState());

      RegisterRequest registerRequest = RegisterRequest(
        password: password,
        email: email,
        name: name,
        rePassword: rePassword,
        phone: phone,
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

// todo: view => viewmodel
// todo: viewModel => usecase
// todo: usecase => repository
// todo: repository => Remote data source
// todo: Remote data source => Api Srevices
