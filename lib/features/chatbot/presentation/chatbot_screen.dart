import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/features/chatbot/models/chat_message_model.dart';
import 'package:tourist_app/features/chatbot/providers/chat_provider.dart';
import 'package:tourist_app/features/chatbot/widgets/typing_indicator_widget.dart';
import 'package:tourist_app/features/chatbot/widgets/quick_actions_widget.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Auto-scroll to bottom on startup after build
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom(immediate: true));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool immediate = false}) {
    if (_scrollController.hasClients) {
      if (immediate) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      } else {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  void _handleSubmitted(String text, ChatProvider provider) {
    if (text.trim().isEmpty) return;
    _messageController.clear();
    provider.sendMessage(text);
    // Wait for the UI to rebuild before scrolling
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.apptheme == ThemeMode.dark;
    final chatProvider = Provider.of<ChatProvider>(context);

    // Listen for typing state changes or message count changes to auto-scroll
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Padding(
      // Handles keyboard positioning
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          color: isDark ? AppColors.darkBlueColor : AppColors.whiteColor,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: Column(
              children: [
                // 1. Header Bar
                _buildHeader(context, isDark),
                
                // 2. Chat Messages Area
                Expanded(
                  child: chatProvider.messages.isEmpty
                      ? _buildEmptyState(chatProvider)
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          itemCount: chatProvider.messages.length + (chatProvider.isTyping ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == chatProvider.messages.length) {
                              return const TypingIndicatorWidget();
                            }
                            final message = chatProvider.messages[index];
                            return _buildMessageRow(message, chatProvider, isDark);
                          },
                        ),
                ),

                // 3. Quick Actions Suggestions (scrolling row)
                QuickActionsWidget(
                  onActionTap: (action) => _handleSubmitted(action, chatProvider),
                ),

                const SizedBox(height: 4),

                // 4. Input Area
                _buildInputArea(context, chatProvider, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: isDark ? AppColors.bottomNavigationColor : AppColors.primaryColor,
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Bot Avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFC9A646), Color(0xFF3B9388)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.smart_toy_outlined,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            // Title & Status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nefertiti AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981), // Green active dot
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Your Egypt Travel Assistant',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Close Button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ChatProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 48,
              color: AppColors.yellowColor,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Welcome to Egypt!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Ask me anything about historical places, hotels, transportation, local food or custom itineraries.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.lightGrayColor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageRow(ChatMessageModel message, ChatProvider provider, bool isDark) {
    final isUser = message.isUser;
    
    // Formatting helper for timestamps
    final timeStr = "${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}";

    if (isUser) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF3B9388), // Teal color for user
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Text(
                message.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              timeStr,
              style: TextStyle(
                color: isDark ? AppColors.blueColor.withOpacity(0.5) : AppColors.lightGrayColor.withOpacity(0.7),
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
    } else {
      // AI Message
      final bubbleColor = isDark
          ? AppColors.bottomNavigationColor
          : const Color(0xFFF9F9FB);
      final borderColor = isDark
          ? Colors.transparent
          : const Color(0xFFEEEEEE);
      final textColor = isDark ? Colors.white : AppColors.blackColor;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Small Bot Icon
                Container(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.only(right: 8.0, bottom: 4.0),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFC9A646), Color(0xFF3B9388)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
                // Bubble Content
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: bubbleColor,
                      border: Border.all(color: borderColor),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                        bottomLeft: Radius.circular(4),
                      ),
                      boxShadow: isDark
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ],
                    ),
                    child: _buildFormattedText(
                      message.text,
                      TextStyle(
                        color: textColor,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Sub-info: timestamp & quick actions below the bubble
            Padding(
              padding: const EdgeInsets.only(left: 36.0, top: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timeStr,
                    style: TextStyle(
                      color: isDark ? AppColors.blueColor.withOpacity(0.5) : AppColors.lightGrayColor.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  ),
                  
                  // Message-specific quick actions if any
                  if (message.quickActions != null && message.quickActions!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: message.quickActions!.map((action) {
                        return Material(
                          color: const Color(0xFFFBF4E6),
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            onTap: () => _handleSubmitted(action, provider),
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              child: Text(
                                action,
                                style: const TextStyle(
                                  color: Color(0xFFB8963E),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  // Parses markdown-like bold markers "**bold text**" and styles them
  Widget _buildFormattedText(String text, TextStyle baseStyle) {
    final List<InlineSpan> spans = [];
    final RegExp regExp = RegExp(r'\*\*(.*?)\*\*');
    int start = 0;
    
    for (final match in regExp.allMatches(text)) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: baseStyle.copyWith(fontWeight: FontWeight.bold),
      ));
      start = match.end;
    }
    
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }
    
    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: spans,
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, ChatProvider provider, bool isDark) {
    final inputBg = isDark ? AppColors.bottomNavigationColor : const Color(0xFFF3F4F6);
    final isFieldNotEmpty = _messageController.text.trim().isNotEmpty;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBlueColor : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: Row(
        children: [
          // Text Input Container
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: inputBg,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      onChanged: (text) {
                        // Rebuild to toggle send button state
                        setState(() {});
                      },
                      onSubmitted: (text) => _handleSubmitted(text, provider),
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.blackColor,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ask me anything about Egypt...',
                        hintStyle: TextStyle(
                          color: isDark ? AppColors.blueColor.withOpacity(0.5) : AppColors.lightGrayColor,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  // Voice Button Placeholder (Microphone icon)
                  IconButton(
                    icon: Icon(
                      Icons.mic_none_outlined,
                      color: isDark ? AppColors.blueColor : AppColors.lightGrayColor,
                    ),
                    onPressed: () {
                      // Placeholder action
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Voice input is not available in this demo.'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Send Button
          GestureDetector(
            onTap: isFieldNotEmpty ? () => _handleSubmitted(_messageController.text, provider) : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: isFieldNotEmpty
                    ? const LinearGradient(
                        colors: [Color(0xFF3B9388), Color(0xFF2C7A7B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [Colors.grey.shade400, Colors.grey.shade400],
                      ),
                shape: BoxShape.circle,
                boxShadow: isFieldNotEmpty
                    ? [
                        BoxShadow(
                          color: const Color(0xFF3B9388).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : [],
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
