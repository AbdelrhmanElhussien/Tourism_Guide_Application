import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tourist_app/core/exceptions/app_exception.dart';

// class DioInterceptor1 extends InterceptorsWrapper {
//
//   @override
//   void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
//     // TODO: implement onResponse
//     super.onResponse(response, handler);
//   }
//
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     // TODO: implement onRequest
//     super.onRequest(options, handler);
//   }
//
//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     // TODO: implement onError
//     super.onError(err, handler);
//   }
// }
import 'package:tourist_app/core/utils/cache_helper.dart';

class DioInterceptor implements Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // TODO: implement onError
    AppException _exception;

    final responseData = err.response?.data;
    String message = 'Something Went Wrong';

    if (responseData is Map) {
      message =
          responseData['errors']?['msg'] ?? responseData['message'] ?? message;
    } else if (err.response?.statusCode == 403) {
      message = 'You are not authorized as a Service Provider. Please sign in with a provider account.';
    } else if (err.response?.statusCode == 401) {
      message = 'Unauthorized. Please sign in.';
    }
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        _exception = NetworkException(
          message: 'Please Check your internet connection',
        );
        break;

      case DioExceptionType.badResponse:
        _exception = ServerException(
          message: message,
          statusCode: err.response?.statusCode,
        );
        break;

      case DioExceptionType.cancel:
        _exception = UnexcpectedException(message: 'Request was Cancelled');
        break;

      default:
        _exception = UnexcpectedException(message: message);
    }

    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        error: _exception,
        response: err.response,
        type: err.type,
      ),
    );
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('onRequest:${options.baseUrl}');
    final token = CacheHelper.getData(key: 'token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    // TODO: implement onResponse
    print('Stauts Code : ${response.statusCode}');
    handler.next(response);
  }
}
