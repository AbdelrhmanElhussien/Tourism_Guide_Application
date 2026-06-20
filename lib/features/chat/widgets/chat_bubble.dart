import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:tourist_app/features/chat/models/chat_message.dart';
import 'package:tourist_app/core/utils/app_theme.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final String guideImageUrl;

  const ChatBubble({
    super.key,
    required this.message,
    required this.guideImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final timeStr = DateFormat('h:mm a').format(message.timestamp);
    final isDark = Provider.of<Themeprovider>(context).apptheme == ThemeMode.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Guide Avatar (only for guide messages on left)
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: CachedNetworkImageProvider(guideImageUrl),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(width: 8),
          ],
          
          // Message Content + Time
          Expanded(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                _buildMessageContent(context, isMe),
                const SizedBox(height: 4),
                // Timestamp and Checkmark row
                Row(
                  mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    if (!isMe) const SizedBox(width: 8),
                    Text(
                      timeStr,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.blueColor.withOpacity(0.8) : Colors.grey[600],
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.done_all,
                        size: 14,
                        color: Color(0xFF1ABC9C), // Green checkmark matching mockup
                      ),
                    ]
                  ],
                ),
              ],
            ),
          ),
          
          if (isMe) const SizedBox(width: 24), // Offset on right for alignment
        ],
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context, bool isMe) {
    final size = MediaQuery.of(context).size;
    final maxBubbleWidth = size.width * 0.7;
    final isDark = Provider.of<Themeprovider>(context, listen: false).apptheme == ThemeMode.dark;

    switch (message.type) {
      case MessageType.image:
        return Container(
          constraints: BoxConstraints(maxWidth: maxBubbleWidth),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.blueColor.withOpacity(0.18) : Colors.black.withOpacity(0.05),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: message.imageUrl ?? '',
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 180,
                width: maxBubbleWidth,
                color: isDark ? AppColors.bottomNavigationColor : Colors.grey[100],
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.yellowColor),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 180,
                width: maxBubbleWidth,
                color: isDark ? AppColors.bottomNavigationColor : Colors.grey[200],
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
        );

      case MessageType.audio:
        return Container(
          width: 240,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isMe ? AppColors.yellowColor : (isDark ? AppColors.bottomNavigationColor : Colors.white),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(0),
              bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(16),
            ),
            border: Border.all(
              color: isMe ? Colors.transparent : (isDark ? AppColors.blueColor.withOpacity(0.18) : Colors.grey.withOpacity(0.2)),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Play/Mic circle icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isMe ? Colors.white.withOpacity(0.25) : (isDark ? const Color(0xFF223246) : const Color(0xFFFBF6EE)),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.mic,
                  color: isMe ? Colors.white : AppColors.yellowColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Waveform simulator
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 3,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isMe ? Colors.white.withOpacity(0.4) : (isDark ? const Color(0xFF334B65) : Colors.grey[300]),
                            borderRadius: BorderRadius.circular(1.5),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.45, // Progress indicator matching mockup
                          child: Container(
                            height: 3,
                            decoration: BoxDecoration(
                              color: isMe ? Colors.white : AppColors.yellowColor,
                              borderRadius: BorderRadius.circular(1.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Voice ${message.audioDuration ?? "0:00"}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isMe ? Colors.white.withOpacity(0.9) : (isDark ? Colors.white70 : Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case MessageType.text:
        return Container(
          constraints: BoxConstraints(maxWidth: maxBubbleWidth),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isMe ? const Color(0xFFD4A342) : (isDark ? AppColors.bottomNavigationColor : Colors.white), // Custom golden/mustard color or dark background
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(0),
              bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(16),
            ),
            border: Border.all(
              color: isMe ? Colors.transparent : (isDark ? AppColors.blueColor.withOpacity(0.18) : Colors.grey.withOpacity(0.2)),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            message.content,
            style: TextStyle(
              color: isMe ? Colors.white : (isDark ? Colors.white : const Color(0xFF1E3A5F)),
              fontSize: 14,
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
    }
  }
}
