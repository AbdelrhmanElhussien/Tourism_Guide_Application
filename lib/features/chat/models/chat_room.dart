class ChatRoom {
  final String id;
  final String guideId;
  final String guideName;
  final String guideImageUrl;
  final String tourName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isActive;

  ChatRoom({
    required this.id,
    required this.guideId,
    required this.guideName,
    required this.guideImageUrl,
    required this.tourName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isActive,
  });

  ChatRoom copyWith({
    String? id,
    String? guideId,
    String? guideName,
    String? guideImageUrl,
    String? tourName,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    bool? isActive,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      guideId: guideId ?? this.guideId,
      guideName: guideName ?? this.guideName,
      guideImageUrl: guideImageUrl ?? this.guideImageUrl,
      tourName: tourName ?? this.tourName,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      isActive: isActive ?? this.isActive,
    );
  }
}
