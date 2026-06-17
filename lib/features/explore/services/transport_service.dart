import 'package:dio/dio.dart';
import 'package:tourist_app/api/api_constant.dart';
import 'package:tourist_app/features/explore/models/transport_model.dart';

import 'package:tourist_app/core/di/di.dart';

class TransportService {
  final Dio _dio;

  TransportService({Dio? dio})
      : _dio = dio ?? (getIt.isRegistered<Dio>() ? getIt<Dio>() : Dio(BaseOptions(
              baseUrl: ApiConstant.baseUrl,
              receiveTimeout: const Duration(seconds: 10),
              sendTimeout: const Duration(seconds: 10),
            )));

  Future<List<TransportModel>> fetchTransports({int page = 1, int limit = 10}) async {
    try {
      final response = await _dio.get(
        ApiConstant.transportEndPoint,
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic> && data['success'] == true) {
          final List<dynamic> jsonList = data['data'] ?? [];
          return jsonList
              .map((json) => TransportModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }

        if (data is List) {
          return data
              .map((json) => TransportModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }

        throw Exception('Unexpected API response format');
      }

      throw Exception('Failed to load transports (Status: ${response.statusCode})');
    } on DioException catch (e) {
      final errorData = e.response?.data;
      String message = 'Something went wrong';

      if (errorData is Map) {
        message = errorData['errors']?['msg'] ??
            errorData['message'] ??
            message;
      }

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          throw Exception('Please check your internet connection');
        case DioExceptionType.badResponse:
          throw Exception(message);
        case DioExceptionType.cancel:
          throw Exception('Request was cancelled');
        default:
          throw Exception(message);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<TransportModel> fetchTransportDetails(String id) async {
    try {
      final response = await _dio.get('${ApiConstant.transportEndPoint}/$id');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          if (data['success'] == true && data['data'] != null) {
            return TransportModel.fromJson(data['data'] as Map<String, dynamic>);
          }
          return TransportModel.fromJson(data);
        }

        throw Exception('Unexpected API response format');
      }

      throw Exception('Failed to load transport details (Status: ${response.statusCode})');
    } on DioException catch (e) {
      final errorData = e.response?.data;
      String message = 'Something went wrong';

      if (errorData is Map) {
        message = errorData['errors']?['msg'] ??
            errorData['message'] ??
            message;
      }

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          throw Exception('Please check your internet connection');
        case DioExceptionType.badResponse:
          throw Exception(message);
        case DioExceptionType.cancel:
          throw Exception('Request was cancelled');
        default:
          throw Exception(message);
      }
    } catch (e) {
      rethrow;
    }
  }
}
