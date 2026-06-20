import 'package:dio/dio.dart';
import 'package:tourist_app/api/api_constant.dart';
import 'package:tourist_app/core/di/di.dart';

class ChangePasswordService {
  final Dio _dio;

  ChangePasswordService({Dio? dio})
    : _dio =
          dio ??
          (getIt.isRegistered<Dio>()
              ? getIt<Dio>()
              : Dio(
                  BaseOptions(
                    baseUrl: ApiConstant.baseUrl,
                    receiveTimeout: const Duration(seconds: 10),
                    sendTimeout: const Duration(seconds: 10),
                  ),
                ));

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstant.changePasswordEndPoint,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          'Failed to change password (Status: ${response.statusCode})',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    final errorData = e.response?.data;
    String message = 'Something went wrong';

    if (errorData is Map) {
      final errors = errorData['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          message = firstError.first.toString();
        } else {
          message = firstError.toString();
        }
      } else {
        message = (errorData['message'] ?? errorData['error'] ?? message)
            .toString();
      }
    } else if (errorData is String && errorData.isNotEmpty) {
      message = errorData;
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return Exception('Please check your internet connection');
      case DioExceptionType.cancel:
        return Exception('Request was cancelled');
      default:
        return Exception(message);
    }
  }
}
