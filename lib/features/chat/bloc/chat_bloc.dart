import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_app/features/chat/bloc/chat_event.dart';
import 'package:tourist_app/features/chat/bloc/chat_state.dart';
import 'package:tourist_app/features/chat/models/chat_room.dart';
import 'package:tourist_app/features/chat/models/chat_message.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  // Stream controller to simulate real-time socket/firebase updates
  final StreamController<Map<String, dynamic>> _realTimeStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  StreamSubscription? _streamSubscription;

  ChatBloc() : super(ChatState.initial()) {
    on<LoadChatRooms>(_onLoadChatRooms);
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
    on<MarkAsRead>(_onMarkAsRead);

    // Set up the real-time message listener
    _streamSubscription = _realTimeStreamController.stream.listen((data) {
      final roomId = data['roomId'] as String;
      final message = data['message'] as ChatMessage;
      add(ReceiveMessage(roomId: roomId, message: message));
    });
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    _realTimeStreamController.close();
    return super.close();
  }

  void _onLoadChatRooms(LoadChatRooms event, Emitter<ChatState> emit) {
    emit(state.copyWith(isLoadingRooms: true));

    // Mock initial chat rooms matching the screenshot designs exactly
    final mockRooms = [
      ChatRoom(
        id: 'room_ahmed',
        guideId: 'guide_ahmed',
        guideName: 'Ahmed Hassan',
        guideImageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=256',
        tourName: 'Pyramids & Sphinx Full Day',
        lastMessage: "I'll meet you at the main entrance of the Pyra...",
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 2)),
        unreadCount: 2,
        isActive: true,
      ),
      ChatRoom(
        id: 'room_fatma',
        guideId: 'guide_fatma',
        guideName: 'Fatma El-Zahraa',
        guideImageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=256',
        tourName: 'Luxor East & West Bank',
        lastMessage: 'The Karnak Temple visit is scheduled for tomorro...',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
        unreadCount: 0,
        isActive: true,
      ),
      ChatRoom(
        id: 'room_salah',
        guideId: 'guide_salah',
        guideName: 'Mohamed Salah',
        guideImageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=256',
        tourName: 'Nile Felucca Sunset Cruise',
        lastMessage: 'Thank you for choosing me as your guide! 🌟',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 0,
        isActive: false,
      ),
      ChatRoom(
        id: 'room_sara',
        guideId: 'guide_sara',
        guideName: 'Sara Mahmoud',
        guideImageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=256',
        tourName: 'Red Sea Snorkeling Adventure',
        lastMessage: "📍 I've shared the meeting point location.",
        lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
        unreadCount: 0,
        isActive: false,
      ),
    ];

    emit(state.copyWith(
      chatRooms: mockRooms,
      isLoadingRooms: false,
    ));
  }

  void _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) {
    final roomId = event.roomId;
    emit(state.copyWith(isLoadingMessages: true, activeRoomId: roomId));

    final currentMessagesMap = Map<String, List<ChatMessage>>.from(state.messages);

    // If messages aren't populated for this room, add initial mock messages
    if (!currentMessagesMap.containsKey(roomId)) {
      if (roomId == 'room_ahmed') {
        currentMessagesMap[roomId] = [
          ChatMessage(
            id: 'm1',
            senderId: 'guide_ahmed',
            content: "I'll meet you at the main entrance at 8 AM sharp. Here's our meeting point:",
            timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
            type: MessageType.text,
            isMe: false,
          ),
          ChatMessage(
            id: 'm2',
            senderId: 'guide_ahmed',
            content: '',
            timestamp: DateTime.now().subtract(const Duration(minutes: 6)),
            type: MessageType.image,
            imageUrl: 'https://images.unsplash.com/photo-1539650116574-8efeb43e2750?q=80&w=600',
            isMe: false,
          ),
          ChatMessage(
            id: 'm3',
            senderId: 'user_current',
            content: "Perfect, thank you! I'll be there at 8 AM. Can't wait!",
            timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
            type: MessageType.text,
            isMe: true,
          ),
          ChatMessage(
            id: 'm4',
            senderId: 'guide_ahmed',
            content: 'Voice Note',
            timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
            type: MessageType.audio,
            audioDuration: '0:14',
            isMe: false,
          ),
        ];
      } else {
        currentMessagesMap[roomId] = [
          ChatMessage(
            id: 'm_other_1',
            senderId: 'guide_other',
            content: 'Hello! Welcome to our tour guide service.',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            type: MessageType.text,
            isMe: false,
          ),
        ];
      }
    }

    // Automatically mark as read when loading messages
    final updatedRooms = state.chatRooms.map((room) {
      if (room.id == roomId) {
        return room.copyWith(unreadCount: 0);
      }
      return room;
    }).toList();

    emit(state.copyWith(
      messages: currentMessagesMap,
      chatRooms: updatedRooms,
      isLoadingMessages: false,
    ));
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) {
    final roomId = event.roomId;
    final currentMessagesMap = Map<String, List<ChatMessage>>.from(state.messages);

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'user_current',
      content: event.content,
      timestamp: DateTime.now(),
      type: event.type,
      audioDuration: event.audioDuration,
      imageUrl: event.imageUrl,
      isMe: true,
    );

    final roomMessages = List<ChatMessage>.from(currentMessagesMap[roomId] ?? [])..add(newMessage);
    currentMessagesMap[roomId] = roomMessages;

    // Update the last message in the ChatRoom item
    final updatedRooms = state.chatRooms.map((room) {
      if (room.id == roomId) {
        String lastMsg = event.content;
        if (event.type == MessageType.image) {
          lastMsg = 'Sent an image';
        } else if (event.type == MessageType.audio) {
          lastMsg = '🎙️ Voice note';
        }
        return room.copyWith(
          lastMessage: lastMsg,
          lastMessageTime: DateTime.now(),
          unreadCount: 0,
        );
      }
      return room;
    }).toList();

    emit(state.copyWith(
      messages: currentMessagesMap,
      chatRooms: updatedRooms,
    ));

    // Simulate guides reply if it's Ahmed Hassan's room after 2 seconds
    if (roomId == 'room_ahmed') {
      Timer(const Duration(seconds: 2), () {
        final replyText = _generateMockReply(event.content);
        final guideMessage = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: 'guide_ahmed',
          content: replyText,
          timestamp: DateTime.now(),
          type: MessageType.text,
          isMe: false,
        );
        _realTimeStreamController.add({
          'roomId': roomId,
          'message': guideMessage,
        });
      });
    }
  }

  void _onReceiveMessage(ReceiveMessage event, Emitter<ChatState> emit) {
    final roomId = event.roomId;
    final currentMessagesMap = Map<String, List<ChatMessage>>.from(state.messages);

    final roomMessages = List<ChatMessage>.from(currentMessagesMap[roomId] ?? [])..add(event.message);
    currentMessagesMap[roomId] = roomMessages;

    // Update the ChatRoom details
    final updatedRooms = state.chatRooms.map((room) {
      if (room.id == roomId) {
        final isCurrentRoomActive = state.activeRoomId == roomId;
        return room.copyWith(
          lastMessage: event.message.content,
          lastMessageTime: event.message.timestamp,
          unreadCount: isCurrentRoomActive ? 0 : room.unreadCount + 1,
        );
      }
      return room;
    }).toList();

    emit(state.copyWith(
      messages: currentMessagesMap,
      chatRooms: updatedRooms,
    ));
  }

  void _onMarkAsRead(MarkAsRead event, Emitter<ChatState> emit) {
    final updatedRooms = state.chatRooms.map((room) {
      if (room.id == event.roomId) {
        return room.copyWith(unreadCount: 0);
      }
      return room;
    }).toList();

    emit(state.copyWith(chatRooms: updatedRooms));
  }

  String _generateMockReply(String userMessage) {
    final lower = userMessage.toLowerCase();
    if (lower.contains('hello') || lower.contains('hi')) {
      return "Hello there! Looking forward to showing you the Pyramids and the Sphinx!";
    } else if (lower.contains('time') || lower.contains('when')) {
      return "We are starting at 8:00 AM sharp to beat the crowds and heat. See you soon!";
    } else if (lower.contains('where') || lower.contains('meet')) {
      return "Let's meet at the main ticket counter/entrance. I will be wearing a white cap.";
    } else if (lower.contains('thank') || lower.contains('thanks')) {
      return "You're very welcome! Safe travels!";
    } else {
      return "Got it! I will make sure everything is ready for our Pyramids & Sphinx Full Day tour. Let me know if you have any special requests.";
    }
  }
}
