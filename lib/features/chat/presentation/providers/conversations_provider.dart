import 'package:flutter/material.dart';
import 'package:tourist_app/features/chat/data/models/conversation_model.dart';
import 'package:tourist_app/features/chat/data/repositories/chat_repository.dart';

class ConversationsProvider extends ChangeNotifier {
  final ChatRepository _chatRepository = ChatRepository();

  List<ConversationModel> _conversations = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ConversationModel> get conversations => _conversations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isEmpty => _conversations.isEmpty && !_isLoading && !hasError;

  Future<void> fetchConversations({bool forceRefresh = false}) async {
    if (_conversations.isNotEmpty && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _conversations = await _chatRepository.getConversations();
      // Sort conversations by last message timestamp descending (newest first)
      _conversations.sort((a, b) => b.lastAt.compareTo(a.lastAt));
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateLastMessage(String otherUserId, String text, DateTime timestamp) {
    final index = _conversations.indexWhere((c) => c.otherUserId.toLowerCase() == otherUserId.toLowerCase());
    if (index != -1) {
      final conv = _conversations[index];
      final updated = conv.copyWith(
        lastMessage: text,
        lastAt: timestamp,
      );
      _conversations.removeAt(index);
      _conversations.insert(0, updated);
      notifyListeners();
    } else {
      // If conversation is not in the list, fetch the updated list from server
      fetchConversations(forceRefresh: true);
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearCache() {
    _conversations = [];
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
