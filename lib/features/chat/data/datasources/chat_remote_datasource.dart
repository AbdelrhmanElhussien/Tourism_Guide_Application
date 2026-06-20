import 'package:dio/dio.dart';
import 'package:tourist_app/core/di/di.dart';
import 'package:tourist_app/features/chat/data/models/conversation_model.dart';
import 'package:tourist_app/features/chat/data/models/chat_message_model.dart';
import 'package:tourist_app/api/api_constant.dart';

class ChatRemoteDataSource {
  final Dio _dio;

  ChatRemoteDataSource({Dio? dio})
      : _dio = dio ?? getIt<Dio>();

  Future<List<ConversationModel>> fetchConversations() async {
    try {
      final response = await _dio.get('Chat/myconversations');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data
              .map((json) => ConversationModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }
        throw Exception('Unexpected response format');
      }
      throw Exception('Failed to load conversations (Status: ${response.statusCode})');
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ChatMessageModel>> fetchChatHistory(String userA, String userB) async {
    try {
      // Endpoint is /api/Chat/history/{userA}/{userB}
      final response = await _dio.get('Chat/history/$userA/$userB');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data
              .map((json) => ChatMessageModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }
        throw Exception('Unexpected response format');
      }
      throw Exception('Failed to load chat history (Status: ${response.statusCode})');
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
