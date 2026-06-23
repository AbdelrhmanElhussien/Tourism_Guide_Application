import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tourist_app/core/utils/cache_helper.dart';
import 'package:tourist_app/features/chat/data/models/chat_message_model.dart';
import 'package:tourist_app/features/chat/data/repositories/chat_repository.dart';
import 'package:tourist_app/features/chat/services/signalr_service.dart';
import 'package:tourist_app/features/chat/presentation/providers/conversations_provider.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository _chatRepository = ChatRepository();
  final SignalRService _signalRService = SignalRService();

  List<ChatMessageModel> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _currentUserId;
  String? _guideId;
  StreamSubscription<ChatMessageModel>? _messageSubscription;
  ConversationsProvider? _conversationsProvider;

  List<ChatMessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get currentUserId => _currentUserId;
  String? get guideId => _guideId;
  bool get hasError => _errorMessage != null;
  bool get isEmpty => _messages.isEmpty && !_isLoading && !hasError;

  ChatProvider() {
    _currentUserId = _decodeCurrentUserId();
  }

  String? _decodeCurrentUserId() {
    final token = CacheHelper.getData(key: 'token') as String?;
    print('ChatProvider: Raw Token: $token');
    if (token == null) {
      print('ChatProvider: Token is null in CacheHelper');
      return null;
    }
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        print('ChatProvider: Token parts count is not 3: ${parts.length}');
        return null;
      }
      final payload = parts[1];
      var normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final map = jsonDecode(decoded) as Map<String, dynamic>;
      print('ChatProvider: Decoded JWT Map: $map');
      
      // Check standard claim names for user ID in ASP.NET Core
      final id = map['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier']?.toString() ??
             map['nameid']?.toString() ??
             map['sub']?.toString() ??
             map['uid']?.toString() ??
             map['id']?.toString() ??
             map['userId']?.toString() ??
             map['UserId']?.toString() ??
             map['userid']?.toString() ??
             map['http://schemas.microsoft.com/ws/2008/06/identity/claims/primarysid']?.toString();
      print('ChatProvider: Decoded user ID: $id');
      if (id == null) {
        print('ChatProvider: WARNING: Decoded user ID is null. Available keys in JWT: ${map.keys.toList()}');
      }
      return id;
    } catch (e) {
      print('ChatProvider: Error decoding token: $e');
      return null;
    }
  }

  Future<void> initializeChat({
    required String guideId,
    required ConversationsProvider conversationsProvider,
  }) async {
    _currentUserId = _decodeCurrentUserId();
    _guideId = guideId;
    _conversationsProvider = conversationsProvider;
    _messages = [];
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    print('ChatProvider Debug: currentUserId: $_currentUserId');
    print('ChatProvider Debug: guideId: $_guideId');

    // 1. Fetch Chat History
    await fetchChatHistory();

    // 2. Connect SignalR and listen to stream
    try {
      await _signalRService.connect();
      _subscribeToMessages();
    } catch (e) {
      print('ChatProvider: Failed to establish SignalR connection: $e');
      // We don't crash, since history was loaded and we want the user to still view messages.
    }
  }

  Future<void> fetchChatHistory() async {
    _currentUserId = _decodeCurrentUserId();
    if (_currentUserId == null || _guideId == null) {
      _errorMessage = 'User session not found. Please log in.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final history = await _chatRepository.getChatHistory(_currentUserId!, _guideId!);
      _messages = history;
      // Sort messages ascending by time so they render in chat order (oldest at top, newest at bottom)
      _messages.sort((a, b) => a.sentAt.compareTo(b.sentAt));
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _subscribeToMessages() {
    _messageSubscription?.cancel();
    _messageSubscription = _signalRService.messageStream.listen((message) {
      // Skip echo of our own sent messages — they are already in the list
      // (added optimistically in sendMessage). The server echoes back the
      // sender's own message via ReceiveMessage, so we filter it out.
      final isMine = message.senderId?.toLowerCase() == _currentUserId?.toLowerCase();
      if (isMine) {
        print('ChatProvider: Skipping echo of own message.');
        return;
      }

      // Check if this incoming message belongs to this active conversation
      final otherSide = message.senderId?.toLowerCase() == _currentUserId?.toLowerCase()
          ? message.recipientId
          : message.senderId;
      final threadKey = message.conversationKey ?? otherSide;

      final isMessageForCurrentChat = (threadKey != null && threadKey.toLowerCase() == _guideId?.toLowerCase()) ||
          message.senderId?.toLowerCase() == _guideId?.toLowerCase() ||
          message.recipientId?.toLowerCase() == _guideId?.toLowerCase();

      if (isMessageForCurrentChat) {
        _messages.add(message);
        notifyListeners();

        // Update the conversations list item
        _conversationsProvider?.updateLastMessage(
          _guideId!,
          message.text,
          message.sentAt,
        );
      }
    });
  }

  Future<void> sendMessage(String text) async {
    print('ChatProvider: sendMessage called with text: "$text"');
    print('ChatProvider: _currentUserId: "$_currentUserId", _guideId: "$_guideId"');
    if (text.trim().isEmpty || _currentUserId == null || _guideId == null) {
      print('ChatProvider: sendMessage aborted due to invalid text or null user/guide ID');
      return;
    }

    // 1. Optimistically add the message to the UI immediately
    final optimisticMessage = ChatMessageModel(
      text: text,
      sentAt: DateTime.now(),
      senderId: _currentUserId,
      recipientId: _guideId,
      conversationKey: _guideId,
    );
    _messages.add(optimisticMessage);
    notifyListeners();

    // 2. Send via SignalR
    try {
      print('ChatProvider: Sending message via SignalR to ${_guideId!}...');
      
      // Determine conversationKey from message history if available
      String? convKey;
      for (final msg in _messages) {
        if (msg.conversationKey != null && msg.conversationKey!.isNotEmpty && msg.conversationKey != _guideId) {
          convKey = msg.conversationKey;
          break;
        }
      }
      
      // If we don't have it in history but the current user is a customer, the guideId itself is the conversationKey.
      final role = (CacheHelper.getData(key: 'role') as String? ?? '').toLowerCase();
      final isProvider = role == 'provider' || role == 'serviceprovider' || role == 'service provider';
      if (!isProvider && convKey == null) {
        convKey = _guideId;
      }
      
      await _signalRService.sendMessage(_guideId!, text, conversationKey: convKey);
      print('ChatProvider: Message sent successfully via SignalR with convKey: $convKey');
    } catch (e) {
      print('ChatProvider: Failed to send message via SignalR: $e');
      // Remove the optimistic message on failure
      _messages.remove(optimisticMessage);
      _errorMessage = 'Failed to send message: ${e.toString()}';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _signalRService.dispose();
    super.dispose();
  }
}
