import 'package:dio/dio.dart';
import 'package:tourist_app/api/api_constant.dart';
import 'package:tourist_app/core/di/di.dart';
import 'package:tourist_app/features/booking/models/booking_model.dart';

class BookingService {
  final Dio _dio;

  BookingService({Dio? dio}) : _dio = dio ?? getIt<Dio>();

  Future<List<BookingModel>> fetchMyBookings() async {
    try {
      final response = await _dio.get(ApiConstant.myBookingsEndPoint);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['success'] == true) {
          final List<dynamic> bookingsJson = data['data'] ?? [];
          return bookingsJson
              .map((json) => BookingModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }
        if (data is List) {
          return data
              .map((json) => BookingModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }
        throw Exception('Unexpected API response format');
      }
      throw Exception('Failed to load bookings (Status: ${response.statusCode})');
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteBooking(String id) async {
    try {
      final response = await _dio.delete('Bookings/CancelBooking/$id');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete booking (Status: ${response.statusCode})');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }
  Future<void> bookItem(String type, String id, {Map<String, dynamic>? data}) async {
    String endpoint;
    switch (type.toLowerCase()) {
      case 'guide':
        endpoint = ApiConstant.bookGuideEndPoint.replaceAll('{id}', id);
        break;
      case 'hotel':
        endpoint = ApiConstant.bookHotelEndPoint.replaceAll('{id}', id);
        break;
      case 'program':
        endpoint = ApiConstant.bookProgramEndPoint.replaceAll('{id}', id);
        break;
      case 'service':
        endpoint = ApiConstant.bookServiceEndPoint.replaceAll('{id}', id);
        break;
      case 'transport':
        endpoint = ApiConstant.bookTransportEndPoint.replaceAll('{id}', id);
        break;
      default:
        throw Exception('Unknown booking type');
    }

    try {
      final response = await _dio.post(
        endpoint,
        data: data ?? {},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to book (Status: ${response.statusCode})');
      }
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
      message = errorData['errors']?['msg'] ?? errorData['message'] ?? errorData['error'] ?? message;
    } else if (errorData is String && errorData.isNotEmpty) {
      message = errorData;
    }

    final statusCode = e.response?.statusCode;
    final statusText = statusCode != null ? ' (Status $statusCode)' : '';

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return Exception('Please check your internet connection');
      case DioExceptionType.badResponse:
        return Exception('$message$statusText');
      case DioExceptionType.cancel:
        return Exception('Request was cancelled');
      default:
        return Exception('$message$statusText');
    }
  }
}
