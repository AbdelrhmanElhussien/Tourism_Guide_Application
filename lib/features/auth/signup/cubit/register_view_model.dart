import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tourist_app/core/exceptions/app_exception.dart';
import 'package:tourist_app/domain/entities/reqeuest/register/register_request.dart';
import 'package:tourist_app/domain/use_cases/signUpUseCase.dart';
import 'package:tourist_app/features/auth/cubit/auth_states.dart';
import 'package:tourist_app/core/di/di.dart';
import 'package:tourist_app/domain/use_cases/profile/get_username_use_case.dart';
import 'package:tourist_app/core/utils/cache_helper.dart';

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
      if (authResponse.token != null) {
        await CacheHelper.saveData(key: 'token', value: authResponse.token);
      }
      
      // Fetch fresh profile details on successful registration to get the correct name/role
      try {
        final user = await getIt<GetUsernameUseCase>().invoke();
        if (user.name != null) {
          await CacheHelper.saveData(key: 'userName', value: user.name);
        } else if (authResponse.userName != null) {
          await CacheHelper.saveData(key: 'userName', value: authResponse.userName);
        }
        if (user.email != null) {
          await CacheHelper.saveData(key: 'email', value: user.email);
        } else if (authResponse.email != null) {
          await CacheHelper.saveData(key: 'email', value: authResponse.email);
        }
        if (user.role != null) {
          await CacheHelper.saveData(key: 'role', value: user.role);
        } else if (authResponse.role != null) {
          await CacheHelper.saveData(key: 'role', value: authResponse.role);
        } else {
          await CacheHelper.removeData(key: 'role');
        }
      } catch (_) {
        // Fallback to auth response parameters if profile fetch fails
        if (authResponse.email != null) {
          await CacheHelper.saveData(key: 'email', value: authResponse.email);
        }
        if (authResponse.userName != null) {
          await CacheHelper.saveData(key: 'userName', value: authResponse.userName);
        }
        if (authResponse.role != null) {
          await CacheHelper.saveData(key: 'role', value: authResponse.role);
        } else {
          await CacheHelper.removeData(key: 'role');
        }
      }

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
