import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/features/chat/data/models/chat_message_model.dart';

class ChatBubbleWidget extends StatelessWidget {
  final ChatMessageModel message;
  final bool isMe;
  final String? guideImageUrl;
  final bool isDark;

  const ChatBubbleWidget({
    super.key,
    required this.message,
    required this.isMe,
    this.guideImageUrl,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('hh:mm a').format(message.sentAt);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: guideImageUrl != null && guideImageUrl!.isNotEmpty
                  ? CachedNetworkImageProvider(guideImageUrl!) as ImageProvider
                  : null,
              backgroundColor: isDark ? AppColors.bottomNavigationColor : Colors.grey[300],
              child: guideImageUrl == null || guideImageUrl!.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 16,
                      color: isDark ? Colors.white70 : Colors.black45,
                    )
                  : null,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isMe
                        ? AppColors.yellowColor
                        : (isDark ? AppColors.bottomNavigationColor : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 16),
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
                    message.text,
                    style: TextStyle(
                      fontSize: 15,
                      color: isMe
                          ? Colors.white
                          : (isDark ? Colors.white : Colors.black87),
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    formattedTime,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? AppColors.blueColor : AppColors.lightGrayColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
