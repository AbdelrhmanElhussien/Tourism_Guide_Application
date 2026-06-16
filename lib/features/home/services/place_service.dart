import 'package:dio/dio.dart';
import 'package:tourist_app/api/api_constant.dart';
import 'package:tourist_app/features/home/models/place_model.dart';

class PlaceService {
  final Dio _dio;

  PlaceService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: ApiConstant.baseUrl,
              receiveTimeout: const Duration(seconds: 10),
              sendTimeout: const Duration(seconds: 10),
            ));

  Future<List<PlaceModel>> fetchPlaces({int page = 1, int limit = 10}) async {
    try {
      final response = await _dio.get(
        ApiConstant.placesEndPoint,
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic> && data['items'] != null) {
          final List<dynamic> placesJson = data['items'] ?? [];
          return placesJson
              .map((json) => PlaceModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }

        if (data is List) {
          return data
              .map((json) => PlaceModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }

        throw Exception('Unexpected API response format');
      }

      throw Exception('Failed to load places (Status: ${response.statusCode})');
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<PlaceModel> fetchPlaceDetails(String id) async {
    try {
      final response = await _dio.get('${ApiConstant.placesEndPoint}/$id');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return PlaceModel.fromJson(data);
        }
        throw Exception('Unexpected API response format');
      }

      throw Exception('Failed to load place details (Status: ${response.statusCode})');
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PlaceModel>> fetchPlacesSummary() async {
    try {
      final response = await _dio.get(ApiConstant.placesSummaryEndPoint);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is List) {
          return data
              .map((json) => PlaceModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }

        throw Exception('Unexpected API response format');
      }

      throw Exception('Failed to load places summary (Status: ${response.statusCode})');
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PlaceModel>> fetchRecommendedPlaces() async {
    try {
      final response = await _dio.get(ApiConstant.recommendedPlacesEndPoint);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is List) {
          return data
              .map((json) => PlaceModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }

        throw Exception('Unexpected API response format');
      }

      throw Exception('Failed to load recommended places (Status: ${response.statusCode})');
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Exception _handleDioError(DioException e) {
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
        return Exception('Please check your internet connection');
      case DioExceptionType.badResponse:
        return Exception(message);
      case DioExceptionType.cancel:
        return Exception('Request was cancelled');
      default:
        return Exception(message);
    }
  }
}
