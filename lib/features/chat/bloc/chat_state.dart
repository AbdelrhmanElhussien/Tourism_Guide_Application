import 'package:tourist_app/features/chat/models/chat_room.dart';
import 'package:tourist_app/features/chat/models/chat_message.dart';

class ChatState {
  final List<ChatRoom> chatRooms;
  final Map<String, List<ChatMessage>> messages; // Map of roomId to list of messages
  final String? activeRoomId;
  final bool isLoadingRooms;
  final bool isLoadingMessages;
  final String? errorMessage;

  const ChatState({
    required this.chatRooms,
    required this.messages,
    this.activeRoomId,
    required this.isLoadingRooms,
    required this.isLoadingMessages,
    this.errorMessage,
  });

  factory ChatState.initial() {
    return const ChatState(
      chatRooms: [],
      messages: {},
      activeRoomId: null,
      isLoadingRooms: false,
      isLoadingMessages: false,
      errorMessage: null,
    );
  }

  ChatState copyWith({
    List<ChatRoom>? chatRooms,
    Map<String, List<ChatMessage>>? messages,
    String? activeRoomId,
    bool? isLoadingRooms,
    bool? isLoadingMessages,
    String? errorMessage,
  }) {
    return ChatState(
      chatRooms: chatRooms ?? this.chatRooms,
      messages: messages ?? this.messages,
      activeRoomId: activeRoomId ?? this.activeRoomId,
      isLoadingRooms: isLoadingRooms ?? this.isLoadingRooms,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
