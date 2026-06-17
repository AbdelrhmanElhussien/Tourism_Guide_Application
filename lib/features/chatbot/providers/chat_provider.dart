import 'package:flutter/material.dart';
import 'package:tourist_app/features/chatbot/models/chat_message_model.dart';
import 'package:tourist_app/features/chatbot/services/ai_chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final AIChatService _chatService = AIChatService();
  final List<ChatMessageModel> _messages = [];
  bool _isTyping = false;

  List<ChatMessageModel> get messages => _messages;
  bool get isTyping => _isTyping;

  ChatProvider() {
    _addInitialGreeting();
  }

  void _addInitialGreeting() {
    if (_messages.isEmpty) {
      _messages.add(
        ChatMessageModel(
          id: 'greeting_${DateTime.now().millisecondsSinceEpoch}',
          text: 'Marhaba! 👋 I\'m Nefertiti, your AI travel assistant for Egypt. I can help you discover amazing places, find hotels, book guides, and plan your perfect Egyptian adventure.\n\nHow can I help you today?',
          isUser: false,
          timestamp: DateTime.now(),
          quickActions: ['Recommend Places', 'Find Hotels', 'Plan My Trip'],
        ),
      );
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}_user',
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    _messages.add(userMessage);
    _isTyping = true;
    notifyListeners();

    try {
      final aiResponseText = await _chatService.getResponse(text);
      
      // We can also suggest different quick actions based on what was asked, or keep it general
      List<String>? newQuickActions;
      if (text.contains('Hotel') || text.contains('stay')) {
        newQuickActions = ['Plan My Trip', 'Transportation Options'];
      } else if (text.contains('Place') || text.contains('recommend')) {
        newQuickActions = ['Find Hotels', 'Find Guides'];
      }

      final aiMessage = ChatMessageModel(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}_ai',
        text: aiResponseText,
        isUser: false,
        timestamp: DateTime.now(),
        quickActions: newQuickActions,
      );

      _messages.add(aiMessage);
    } catch (e) {
      final errorMessage = ChatMessageModel(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}_error',
        text: 'Sorry, I encountered an error. Please try again. 😕',
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(errorMessage);
    } finally {
      _isTyping = false;
      notifyListeners();
    }
  }

  void clearChat() {
    _messages.clear();
    _addInitialGreeting();
    _isTyping = false;
    notifyListeners();
  }
}
