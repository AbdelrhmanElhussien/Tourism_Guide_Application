import 'package:flutter/material.dart';
import 'package:tourist_app/features/chatbot/presentation/chatbot_screen.dart';

class ChatBotBottomSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return const ChatBotScreen();
      },
    );
  }
}
