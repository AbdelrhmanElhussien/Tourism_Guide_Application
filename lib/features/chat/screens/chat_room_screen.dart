import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tourist_app/features/chat/bloc/chat_bloc.dart';
import 'package:tourist_app/features/chat/bloc/chat_event.dart';
import 'package:tourist_app/features/chat/bloc/chat_state.dart';
import 'package:tourist_app/features/chat/models/chat_room.dart';
import 'package:tourist_app/features/chat/models/chat_message.dart';
import 'package:tourist_app/features/chat/widgets/chat_bubble.dart';
import 'package:tourist_app/features/chat/widgets/message_input_field.dart';
import 'package:tourist_app/core/utils/app_theme.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final ScrollController _scrollController = ScrollController();
  late ChatRoom _chatRoom;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is ChatRoom) {
        _chatRoom = args;
      } else {
        // Fallback default in case screen is opened directly
        _chatRoom = ChatRoom(
          id: 'room_ahmed',
          guideId: 'guide_ahmed',
          guideName: 'Ahmed Hassan',
          guideImageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=256',
          tourName: 'Pyramids & Sphinx Full Day',
          lastMessage: '',
          lastMessageTime: DateTime.now(),
          unreadCount: 0,
          isActive: true,
        );
      }
      // Load messages for this chat room
      context.read<ChatBloc>().add(LoadMessages(roomId: _chatRoom.id));
      _isInitialized = true;
      _scrollToBottom(delayMs: 200);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom({int delayMs = 100}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        Timer(Duration(milliseconds: delayMs), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  void _handleSendText(String text) {
    context.read<ChatBloc>().add(
          SendMessage(
            roomId: _chatRoom.id,
            content: text,
            type: MessageType.text,
          ),
        );
    _scrollToBottom();
  }

  void _handleSendImage() {
    // Send a mock image from tourist guide context (Pyramids ticket/view)
    context.read<ChatBloc>().add(
          SendMessage(
            roomId: _chatRoom.id,
            content: '',
            type: MessageType.image,
            imageUrl: 'https://images.unsplash.com/photo-1539650116574-8efeb43e2750?q=80&w=600',
          ),
        );
    _scrollToBottom();
  }

  void _handleSendAudio() {
    // Send a mock voice message
    context.read<ChatBloc>().add(
          SendMessage(
            roomId: _chatRoom.id,
            content: 'Voice Note',
            type: MessageType.audio,
            audioDuration: '0:14',
          ),
        );
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<Themeprovider>(context).apptheme == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBlueColor : Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? AppColors.darkBlueColor : Colors.white,
        leadingWidth: 40,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : const Color(0xFF1E3A5F),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            // Guide Avatar with active indicator
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: CachedNetworkImageProvider(_chatRoom.guideImageUrl),
                  backgroundColor: Colors.grey[200],
                ),
                if (_chatRoom.isActive)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1ABC9C),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? AppColors.darkBlueColor : Colors.white,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            // Name and Status Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _chatRoom.guideName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E3A5F),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        _chatRoom.isActive ? 'Online' : 'Offline',
                        style: TextStyle(
                          fontSize: 11,
                          color: _chatRoom.isActive ? const Color(0xFF1ABC9C) : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.brightness_1,
                        size: 4,
                        color: isDark ? AppColors.blueColor : Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.star, color: Colors.amber, size: 12),
                      const SizedBox(width: 2),
                      Text(
                        '4.9', // Mock rating as shown in Ahmed Hassan Chat UI
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.phone_outlined, color: isDark ? Colors.white : const Color(0xFF1E3A5F)),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.videocam_outlined, color: isDark ? Colors.white : const Color(0xFF1E3A5F)),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: isDark ? Colors.white : const Color(0xFF1E3A5F)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Subheader: Tour name with green dot/bullet
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: isDark ? const Color(0xFF0C242E) : const Color(0xFFEAF6F4), // Light/dark teal background matching mockup
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1ABC9C),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _chatRoom.tourName,
                  style: const TextStyle(
                    color: Color(0xFF1ABC9C),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          // Messages history
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                // If a new message is appended, auto scroll to bottom
                _scrollToBottom();
              },
              builder: (context, state) {
                if (state.isLoadingMessages && !(state.messages[_chatRoom.id]?.isNotEmpty ?? false)) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.yellowColor),
                  );
                }

                final messagesList = state.messages[_chatRoom.id] ?? [];

                if (messagesList.isEmpty) {
                  return Center(
                    child: Text(
                      'No messages yet. Say hello to ${_chatRoom.guideName}!',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  itemCount: messagesList.length,
                  itemBuilder: (context, index) {
                    final message = messagesList[index];
                    return ChatBubble(
                      key: ValueKey(message.id), // Ensure proper list items rebuilding
                      message: message,
                      guideImageUrl: _chatRoom.guideImageUrl,
                    );
                  },
                );
              },
            ),
          ),
          
          // Bottom message input field
          MessageInputField(
            onSendText: _handleSendText,
            onSendImage: _handleSendImage,
            onSendAudio: _handleSendAudio,
          ),
        ],
      ),
    );
  }
}
