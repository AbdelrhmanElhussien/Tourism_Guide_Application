import 'package:tourist_app/features/chat/models/chat_message.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class LoadChatRooms extends ChatEvent {}

class LoadMessages extends ChatEvent {
  final String roomId;

  const LoadMessages({required this.roomId});
}

class SendMessage extends ChatEvent {
  final String roomId;
  final String content;
  final MessageType type;
  final String? audioDuration;
  final String? imageUrl;

  const SendMessage({
    required this.roomId,
    required this.content,
    required this.type,
    this.audioDuration,
    this.imageUrl,
  });
}

class ReceiveMessage extends ChatEvent {
  final String roomId;
  final ChatMessage message;

  const ReceiveMessage({required this.roomId, required this.message});
}

class MarkAsRead extends ChatEvent {
  final String roomId;

  const MarkAsRead({required this.roomId});
}
