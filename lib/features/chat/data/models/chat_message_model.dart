class ChatMessageModel {
  final String text;
  final DateTime sentAt;
  final String? senderId;
  final String? recipientId;
  final String? conversationKey;

  ChatMessageModel({
    required this.text,
    required this.sentAt,
    this.senderId,
    this.recipientId,
    this.conversationKey,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    // Parse senderId from common keys, just in case the backend returns it
    final parsedSenderId = json['senderId'] as String? ?? 
                           json['SenderId'] as String? ?? 
                           json['fromUserId'] as String? ?? 
                           json['userId'] as String? ?? 
                           json['sender'] as String?;
                           
    final parsedRecipientId = json['recipientId'] as String? ??
                              json['RecipientId'] as String? ??
                              json['toUserId'] as String? ??
                              json['receiverId'] as String?;

    final parsedConversationKey = json['conversationKey'] as String? ??
                                  json['ConversationKey'] as String?;

    return ChatMessageModel(
      text: json['text'] as String? ?? json['Text'] as String? ?? '',
      sentAt: DateTime.tryParse(json['sentAt'] as String? ?? json['SentAt'] as String? ?? '') ?? DateTime.now(),
      senderId: parsedSenderId,
      recipientId: parsedRecipientId,
      conversationKey: parsedConversationKey,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'sentAt': sentAt.toIso8601String(),
      if (senderId != null) 'senderId': senderId,
      if (recipientId != null) 'recipientId': recipientId,
      if (conversationKey != null) 'conversationKey': conversationKey,
    };
  }

  ChatMessageModel copyWith({
    String? text,
    DateTime? sentAt,
    String? senderId,
    String? recipientId,
    String? conversationKey,
  }) {
    return ChatMessageModel(
      text: text ?? this.text,
      sentAt: sentAt ?? this.sentAt,
      senderId: senderId ?? this.senderId,
      recipientId: recipientId ?? this.recipientId,
      conversationKey: conversationKey ?? this.conversationKey,
    );
  }

  bool isMe(String currentUserId) {
    if (senderId == null) return false;
    // Compare ignore case or exact
    return senderId!.toLowerCase() == currentUserId.toLowerCase();
  }
}
