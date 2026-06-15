import 'package:dio/dio.dart';
import 'package:tourist_app/api/api_constant.dart';
import 'package:tourist_app/features/guide/models/guide_model.dart';

class GuideService {
  final Dio _dio;

  GuideService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: ApiConstant.baseUrl,
              receiveTimeout: const Duration(seconds: 10),
              sendTimeout: const Duration(seconds: 10),
            ));

  Future<List<GuideModel>> fetchGuides({int page = 1, int limit = 10}) async {
    try {
      final response = await _dio.get(
        ApiConstant.guidesEndPoint,
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic> && data['success'] == true) {
          final List<dynamic> guidesJson = data['data'] ?? [];
          return guidesJson
              .map((json) => GuideModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }

        if (data is List) {
          return data
              .map((json) => GuideModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }

        throw Exception('Unexpected API response format');
      }

      throw Exception('Failed to load guides (Status: ${response.statusCode})');
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
