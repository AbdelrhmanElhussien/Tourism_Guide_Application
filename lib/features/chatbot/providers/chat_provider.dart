import 'package:flutter/material.dart';
import 'package:tourist_app/features/chatbot/models/chat_message_model.dart';
import 'package:tourist_app/features/chatbot/data/repositories/chatbot_repository.dart';

class ChatProvider extends ChangeNotifier {
  final ChatBotRepository _chatbotRepository = ChatBotRepository();
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
          text: 'Marhaba! 👋 I\'m Nefertiti, your AI travel assistant specialized in Aswan tourism. I can help you discover amazing historical sites, find hotels, book local guides, and plan transportation.\n\nHow can I help you today?',
          isUser: false,
          timestamp: DateTime.now(),
          quickActions: ['Recommend Places', 'Find Hotels', 'Find Guides', 'Transportation Options'],
        ),
      );
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 1. Add User message immediately to the UI
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
      // 2. Call the backend ChatBot endpoint with timeout/error safety
      final response = await _chatbotRepository.sendMessage(text);
      
      // Determine relevant quick actions based on what was asked/received
      List<String>? newQuickActions;
      final textLower = text.toLowerCase();
      if (textLower.contains('hotel') || textLower.contains('stay') || textLower.contains('accommodation')) {
        newQuickActions = ['Find Guides', 'Transportation Options'];
      } else if (textLower.contains('place') || textLower.contains('recommend') || textLower.contains('attract')) {
        newQuickActions = ['Find Hotels', 'Plan My Trip'];
      } else {
        newQuickActions = ['Recommend Places', 'Nearby Attractions', 'Find Hotels'];
      }

      // 3. Add the AI response message to the UI
      final aiMessage = ChatMessageModel(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}_ai',
        text: response.message,
        isUser: false,
        timestamp: DateTime.now(),
        quickActions: newQuickActions,
      );

      _messages.add(aiMessage);
    } catch (e) {
      // 4. Handle errors and display a friendly system message
      final errString = e.toString().replaceAll('Exception: ', '');
      final errorMessage = ChatMessageModel(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}_error',
        text: 'Sorry, I couldn\'t fetch a reply from Nefertiti AI. 😕\n\n*Error Detail:* $errString\nPlease verify your connection and try again.',
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
