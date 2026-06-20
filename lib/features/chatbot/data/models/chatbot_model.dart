class ChatBotRequest {
  final String message;

  ChatBotRequest({required this.message});

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}

class ChatBotResponse {
  final String message;

  ChatBotResponse({required this.message});

  factory ChatBotResponse.fromJson(Map<String, dynamic> json) {
    // Gracefully handle various common JSON keys for the chatbot answer
    final responseText = json['message'] as String? ?? 
                         json['response'] as String? ?? 
                         json['reply'] as String? ?? 
                         json['text'] as String? ?? 
                         '';
    return ChatBotResponse(message: responseText);
  }
}
