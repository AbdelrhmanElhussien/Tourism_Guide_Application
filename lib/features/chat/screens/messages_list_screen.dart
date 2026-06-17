import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/features/chat/bloc/chat_bloc.dart';
import 'package:tourist_app/features/chat/bloc/chat_event.dart';
import 'package:tourist_app/features/chat/bloc/chat_state.dart';
import 'package:tourist_app/features/chat/widgets/guide_chat_tile.dart';
import 'package:tourist_app/core/utils/app_routes.dart';
import 'package:tourist_app/core/utils/app_theme.dart';

class MessagesListScreen extends StatefulWidget {
  const MessagesListScreen({super.key});

  @override
  State<MessagesListScreen> createState() => _MessagesListScreenState();
}

class _MessagesListScreenState extends State<MessagesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load chat rooms when screen opens
    context.read<ChatBloc>().add(LoadChatRooms());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<Themeprovider>(context).apptheme == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBlueColor : Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? AppColors.darkBlueColor : Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : const Color(0xFF1E3A5F),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Messages',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1E3A5F),
          ),
        ),
        actions: [
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              final totalUnread = state.chatRooms.fold(0, (sum, room) => sum + room.unreadCount);
              if (totalUnread == 0) return const SizedBox.shrink();

              return Container(
                margin: const EdgeInsets.only(right: 16.0),
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppColors.yellowColor, // Golden/mustard badge matching mockup
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  child: Center(
                    child: Text(
                      '$totalUnread',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: isDark ? AppColors.bottomNavigationColor : const Color(0xFFF7F5F0),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.trim().toLowerCase();
                  });
                },
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1E3A5F),
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
                  hintStyle: TextStyle(
                    color: isDark ? AppColors.blueColor : const Color(0xFFAAAAAA),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark ? AppColors.blueColor : const Color(0xFF6B7280),
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Active Chat List
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state.isLoadingRooms) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.yellowColor),
                  );
                }

                // Filter rooms by search query
                final filteredRooms = state.chatRooms.where((room) {
                  return room.guideName.toLowerCase().contains(_searchQuery) ||
                      room.tourName.toLowerCase().contains(_searchQuery) ||
                      room.lastMessage.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filteredRooms.isEmpty) {
                  return Center(
                    child: Text(
                      'No active conversations found',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: filteredRooms.length,
                  separatorBuilder: (context, index) => Divider(
                    color: isDark ? const Color(0xff162535) : Colors.grey[200],
                    height: 1,
                    indent: 0,
                  ),
                  itemBuilder: (context, index) {
                    final room = filteredRooms[index];
                    return GuideChatTile(
                      chatRoom: room,
                      onTap: () {
                        // Mark room as read and navigate to room
                        context.read<ChatBloc>().add(MarkAsRead(roomId: room.id));
                        Navigator.pushNamed(
                          context,
                          AppRoutes.chatRoomRouteName, // Make sure this matches the route name
                          arguments: room,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
