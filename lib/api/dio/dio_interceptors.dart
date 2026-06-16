import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print('onRequest:${options.baseUrl}');
    
    // Check if token exists
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');
    if (token != null && token.isNotEmpty) {
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
