import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:tourist_app/features/chat/models/chat_room.dart';
import 'package:tourist_app/core/utils/app_theme.dart';

class GuideChatTile extends StatelessWidget {
  final ChatRoom chatRoom;
  final VoidCallback onTap;

  const GuideChatTile({
    super.key,
    required this.chatRoom,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<Themeprovider>(context).apptheme == ThemeMode.dark;

    // Formatting last message time
    String timeStr = '';
    final now = DateTime.now();
    final difference = now.difference(chatRoom.lastMessageTime);

    if (difference.inMinutes < 60) {
      timeStr = '${difference.inMinutes}m ago';
      if (difference.inMinutes <= 0) timeStr = 'Just now';
    } else if (difference.inHours < 24) {
      timeStr = '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      timeStr = 'Yesterday';
    } else {
      timeStr = DateFormat('MMM d').format(chatRoom.lastMessageTime);
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Guide Avatar with Online Badge
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: CachedNetworkImageProvider(chatRoom.guideImageUrl),
                  backgroundColor: Colors.grey[200],
                ),
                Positioned(
                  bottom: 0,
                  right: 2,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: chatRoom.isActive ? const Color(0xFF1ABC9C) : const Color(0xFF6B7280),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.darkBlueColor : Colors.white,
                        width: 2.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Middle section (Name, Tour name, Last message snippet)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chatRoom.guideName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF1E3A5F),
                        ),
                      ),
                      Text(
                        timeStr,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.blueColor : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  // Tour Name in custom green/teal color
                  Text(
                    chatRoom.tourName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1ABC9C), // Custom teal/green matching mockup
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Message Snippet
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          chatRoom.lastMessage,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: chatRoom.unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
                            color: isDark
                                ? (chatRoom.unreadCount > 0 ? Colors.white : AppColors.blueColor)
                                : (chatRoom.unreadCount > 0 ? const Color(0xFF1E3A5F) : Colors.grey[600]),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Unread Badge
                      if (chatRoom.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.yellowColor, // Golden/mustard badge background
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Center(
                            child: Text(
                              '${chatRoom.unreadCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
