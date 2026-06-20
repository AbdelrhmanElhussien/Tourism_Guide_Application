class ChatMessageModel {
  final String text;
  final DateTime sentAt;
  final String? senderId;

  ChatMessageModel({
    required this.text,
    required this.sentAt,
    this.senderId,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    // Parse senderId from common keys, just in case the backend returns it
    final parsedSenderId = json['senderId'] as String? ?? 
                           json['SenderId'] as String? ?? 
                           json['fromUserId'] as String? ?? 
                           json['userId'] as String? ?? 
                           json['sender'] as String?;
                           
    return ChatMessageModel(
      text: json['text'] as String? ?? json['Text'] as String? ?? '',
      sentAt: DateTime.tryParse(json['sentAt'] as String? ?? json['SentAt'] as String? ?? '') ?? DateTime.now(),
      senderId: parsedSenderId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'sentAt': sentAt.toIso8601String(),
      if (senderId != null) 'senderId': senderId,
    };
  }

  ChatMessageModel copyWith({
    String? text,
    DateTime? sentAt,
    String? senderId,
  }) {
    return ChatMessageModel(
      text: text ?? this.text,
      sentAt: sentAt ?? this.sentAt,
      senderId: senderId ?? this.senderId,
    );
  }

  bool isMe(String currentUserId) {
    if (senderId == null) return false;
    // Compare ignore case or exact
    return senderId!.toLowerCase() == currentUserId.toLowerCase();
  }
}
