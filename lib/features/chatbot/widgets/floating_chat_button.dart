import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/features/chatbot/widgets/chatbot_bottom_sheet.dart';

class FloatingChatButton extends StatefulWidget {
  const FloatingChatButton({super.key});

  @override
  State<FloatingChatButton> createState() => _FloatingChatButtonState();
}

class _FloatingChatButtonState extends State<FloatingChatButton>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  Timer? _expansionTimer;
  Timer? _collapseTimer;

  @override
  void initState() {
    super.initState();
    // Expand the button after 1.5 seconds to attract attention
    _expansionTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isExpanded = true;
        });
      }
    });

    // Collapse the button back to idle circular state after another 4 seconds
    _collapseTimer = Timer(const Duration(milliseconds: 6000), () {
      if (mounted) {
        setState(() {
          _isExpanded = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _expansionTimer?.cancel();
    _collapseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.apptheme == ThemeMode.dark;

    // Premium gradient: matching the Nefertiti AI styling (gold/teal blend)
    const gradient = LinearGradient(
      colors: [Color(0xFFC9A646), Color(0xFF3B9388)],
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
          onTap: () {
            // Collapse label on tap and open the bottom sheet
            setState(() {
              _isExpanded = false;
            });
            ChatBotBottomSheet.show(context);
          },
          child: Material(
            elevation: 4,
            shadowColor: shadowColor,
            borderRadius: BorderRadius.circular(28),
            color: Colors.transparent,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOutBack,
              height: 56,
              width: _isExpanded ? 190 : 56,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(28),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon (Sparkles / Chatbot)
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 24,
                    ),
                    
                    // Animated text label
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: _isExpanded ? 140 : 0,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 250),
                        opacity: _isExpanded ? 1.0 : 0.0,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Text(
                            'AI Travel Assistant',
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
