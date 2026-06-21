import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:tourist_app/features/chat/presentation/providers/conversations_provider.dart';
import 'package:tourist_app/features/chat/presentation/widgets/chat_bubble_widget.dart';
import 'package:tourist_app/features/chat/data/repositories/chat_repository.dart';
import 'package:tourist_app/features/chat/models/chat_room.dart';

class ChatDetailsScreen extends StatefulWidget {
  const ChatDetailsScreen({super.key});

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  bool _isInit = true;
  String? _guideId;
  String? _guideName;
  String? _guideImageUrl;
  final ChatRepository _chatRepository = ChatRepository();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String) {
        _guideId = args;
      } else if (args is Map) {
        _guideId = args['guideId']?.toString();
        _guideName = args['guideName']?.toString();
        _guideImageUrl = args['guideImageUrl']?.toString();
      } else if (args is ChatRoom) {
        _guideId = args.guideId;
        _guideName = args.guideName;
        _guideImageUrl = args.guideImageUrl;
      }

      _guideName ??= 'Tour Guide';

      if (_guideId != null) {
        // Initialize state
        final conversationsProvider = Provider.of<ConversationsProvider>(context, listen: false);
        final chatProvider = Provider.of<ChatProvider>(context, listen: false);
        
        chatProvider.initializeChat(
          guideId: _guideId!,
          conversationsProvider: conversationsProvider,
        ).then((_) {
          _scrollToBottom(delayMs: 300);
        });

        // Resolve guide name/image if not passed in navigation
        if (_guideImageUrl == null || _guideImageUrl!.isEmpty || _guideName == 'Tour Guide') {
          _chatRepository.getGuideDetails(_guideId!).then((guide) {
            if (guide != null && mounted) {
              setState(() {
                _guideName = guide.fullName;
                _guideImageUrl = guide.imageUrl;
              });
            }
          });
        }
      }
      _isInit = false;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _scrollToBottom({int delayMs = 100}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        Future.delayed(Duration(milliseconds: delayMs), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  void _handleSendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    context.read<ChatProvider>().sendMessage(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.apptheme == ThemeMode.dark;

    final hasAvatar = _guideImageUrl != null && _guideImageUrl!.isNotEmpty;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBlueColor : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: hasAvatar
                  ? CachedNetworkImageProvider(_guideImageUrl!) as ImageProvider
                  : null,
              backgroundColor: isDark ? AppColors.bottomNavigationColor : Colors.grey[200],
              child: !hasAvatar
                  ? Icon(
                      Icons.person,
                      size: 18,
                      color: isDark ? Colors.white70 : Colors.black45,
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _guideName ?? 'Tour Guide',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Online',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.messages.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.yellowColor),
                  );
                }

                if (provider.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                          const SizedBox(height: 12),
                          Text(
                            provider.errorMessage ?? 'Failed to load messages',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => provider.fetchChatHistory(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // If messages is updated, scroll to bottom
                _scrollToBottom();

                if (provider.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 64,
                          color: isDark ? AppColors.blueColor.withOpacity(0.5) : Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No messages yet',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Say hello to start the conversation!',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.blueColor : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: provider.messages.length,
                  itemBuilder: (context, index) {
                    final message = provider.messages[index];
                    final isMe = message.isMe(provider.currentUserId ?? '');
                    return ChatBubbleWidget(
                      message: message,
                      isMe: isMe,
                      guideImageUrl: _guideImageUrl,
                      isDark: isDark,
                    );
                  },
                );
              },
            ),
          ),

          // Message Input Field
          _buildMessageInput(isDark),
        ],
      ),
    );
  }

  Widget _buildMessageInput(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bottomNavigationColor : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBlueColor : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? Colors.white10 : Colors.transparent,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _messageController,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(
                      color: isDark ? AppColors.blueColor : AppColors.lightGrayColor,
                    ),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _handleSendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.yellowColor,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: _handleSendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
