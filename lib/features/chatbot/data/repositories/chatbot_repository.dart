import 'package:dio/dio.dart';
import 'package:tourist_app/core/di/di.dart';
import 'package:tourist_app/features/chatbot/data/models/chatbot_model.dart';

class ChatBotRepository {
  final Dio _dio = getIt<Dio>();

  Future<ChatBotResponse> sendMessage(String text) async {
    try {
      final response = await _dio.post(
        'ChatBot',
        data: {
          'message': text,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is String) {
          return ChatBotResponse(message: response.data as String);
        } else if (response.data is Map<String, dynamic>) {
          return ChatBotResponse.fromJson(response.data as Map<String, dynamic>);
        } else {
          throw Exception('Format of response is unexpected.');
        }
      } else {
        throw Exception('Server returned error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      String errorMessage = 'A network error occurred. Please try again.';
      if (e.response?.data != null) {
        final data = e.response?.data;
        if (data is Map) {
          errorMessage = data['message'] ?? 
                         (data['errors'] is Map ? (data['errors'] as Map).values.first.toString() : null) ?? 
                         errorMessage;
        } else if (data is String && data.isNotEmpty) {
          errorMessage = data;
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Connection timeout. Please check your internet connection.';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
