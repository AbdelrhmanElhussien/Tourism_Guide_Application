import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/features/chatbot/widgets/chatbot_bottom_sheet.dart';

class FloatingChatButton extends StatelessWidget {
  const FloatingChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.apptheme == ThemeMode.dark;

    // Premium gradient matching the Nefertiti AI styling (gold to teal blend)
    const gradient = LinearGradient(
      colors: [
        Color(0xFFC9A646), // Gold / Yellow
        Color(0xFF3B9388), // Teal / Green
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    // Box shadow for Material 3 design elevation
    final shadowColor = isDark
        ? Colors.black.withOpacity(0.4)
        : const Color(0xFF3B9388).withOpacity(0.3);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () => ChatBotBottomSheet.show(context),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: gradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}
