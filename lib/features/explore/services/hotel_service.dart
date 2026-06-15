import 'package:dio/dio.dart';
import 'package:tourist_app/api/api_constant.dart';
import 'package:tourist_app/features/explore/models/hotel_model.dart';

class HotelService {
  final Dio _dio;

  HotelService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: ApiConstant.baseUrl,
              receiveTimeout: const Duration(seconds: 10),
              sendTimeout: const Duration(seconds: 10),
            ));

  Future<List<HotelModel>> fetchHotels() async {
    try {
      final response = await _dio.get(ApiConstant.hotelsEndPoint);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic> && data['success'] == true) {
          final List<dynamic> hotelsJson = data['data'] ?? [];
          return hotelsJson
              .map((json) => HotelModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }

        if (data is List) {
          return data
              .map((json) => HotelModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }

        throw Exception('Unexpected API response format');
      }

      throw Exception('Failed to load hotels (Status: ${response.statusCode})');
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
