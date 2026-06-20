class ConversationModel {
  final String otherUserId;
  final String lastMessage;
  final DateTime lastAt;
  
  // Optional client-side fields to hold guide details once resolved
  String? otherUserName;
  String? otherUserImageUrl;

  ConversationModel({
    required this.otherUserId,
    required this.lastMessage,
    required this.lastAt,
    this.otherUserName,
    this.otherUserImageUrl,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      otherUserId: json['otherUserId'] as String? ?? json['OtherUserId'] as String? ?? '',
      lastMessage: json['lastMessage'] as String? ?? json['LastMessage'] as String? ?? '',
      lastAt: DateTime.tryParse(json['lastAt'] as String? ?? json['LastAt'] as String? ?? '') ?? DateTime.now(),
      otherUserName: json['otherUserName'] as String? ?? json['OtherUserName'] as String?,
      otherUserImageUrl: json['otherUserImageUrl'] as String? ?? json['OtherUserImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'otherUserId': otherUserId,
      'lastMessage': lastMessage,
      'lastAt': lastAt.toIso8601String(),
      if (otherUserName != null) 'otherUserName': otherUserName,
      if (otherUserImageUrl != null) 'otherUserImageUrl': otherUserImageUrl,
    };
  }

  ConversationModel copyWith({
    String? otherUserId,
    String? lastMessage,
    DateTime? lastAt,
    String? otherUserName,
    String? otherUserImageUrl,
  }) {
    return ConversationModel(
      otherUserId: otherUserId ?? this.otherUserId,
      lastMessage: lastMessage ?? this.lastMessage,
      lastAt: lastAt ?? this.lastAt,
      otherUserName: otherUserName ?? this.otherUserName,
      otherUserImageUrl: otherUserImageUrl ?? this.otherUserImageUrl,
    );
  }
}
