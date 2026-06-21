import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:tourist_app/core/exceptions/app_exception.dart';
import 'package:tourist_app/domain/entities/reqeuest/login/login_request.dart';
import 'package:tourist_app/domain/entities/response/auth/auth_response.dart';
import 'package:tourist_app/domain/use_cases/loginInUseCase.dart';
import 'package:tourist_app/features/auth/cubit/auth_states.dart';
import 'package:tourist_app/core/di/di.dart';
import 'package:tourist_app/domain/use_cases/profile/get_username_use_case.dart';
import 'package:tourist_app/core/utils/cache_helper.dart';

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
        await CacheHelper.saveData(key: 'token', value: authResponse.token);
      }

      // Fetch fresh profile details on successful login to get the correct name/role
      try {
        final user = await getIt<GetUsernameUseCase>().invoke();
        if (user.name != null) {
          await CacheHelper.saveData(key: 'userName', value: user.name);
        } else if (authResponse.userName != null) {
          await CacheHelper.saveData(
            key: 'userName',
            value: authResponse.userName,
          );
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
          await CacheHelper.saveData(
            key: 'userName',
            value: authResponse.userName,
          );
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

  Future<void> loginWithGoogle() async {
    try {
      emit(AuthLoadingState());

      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        serverClientId:
            '734311980915-kttjid11mqljn8e2vsvdc9tqh8edpuir.apps.googleusercontent.com',
      );

      final googleUser = await googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final firebaseUser = userCredential.user;

      if (firebaseUser == null || firebaseUser.email == null) {
        throw FirebaseAuthException(
          code: 'missing-google-user',
          message: 'Google account did not return an email address.',
        );
      }

      await CacheHelper.removeData(key: 'token');
      await CacheHelper.saveData(key: 'email', value: firebaseUser.email);
      await CacheHelper.saveData(
        key: 'userName',
        value: firebaseUser.displayName ?? firebaseUser.email,
      );
      await CacheHelper.saveData(key: 'role', value: 'customer');
      await CacheHelper.saveData(key: 'authProvider', value: 'google');
      await CacheHelper.saveData(key: 'firebaseUid', value: firebaseUser.uid);

      emit(
        AuthSuccessState(
          authResponse: Auth_response(
            message: 'Google sign-in successful',
            email: firebaseUser.email,
            userName: firebaseUser.displayName,
            role: 'customer',
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      emit(
        AuthErrorState(
          errorMsg: ServerException(
            message: e.message ?? 'Google sign-in failed.',
          ),
        ),
      );
    } catch (e) {
      emit(
        AuthErrorState(errorMsg: UnexcpectedException(message: e.toString())),
      );
    }
  }
}
