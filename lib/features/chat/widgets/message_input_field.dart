import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';

class MessageInputField extends StatefulWidget {
  final Function(String) onSendText;
  final VoidCallback onSendImage;
  final VoidCallback onSendAudio;

  const MessageInputField({
    super.key,
    required this.onSendText,
    required this.onSendImage,
    required this.onSendAudio,
  });

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _isTyping) {
      setState(() {
        _isTyping = hasText;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSendText(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<Themeprovider>(context).apptheme == ThemeMode.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBlueColor : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF162535) : Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Attachment Button
            IconButton(
              icon: Icon(
                Icons.attachment_outlined,
                color: isDark ? AppColors.blueColor : const Color(0xFF6B7280),
                size: 26,
              ),
              onPressed: widget.onSendImage,
            ),
            const SizedBox(width: 8),
            // Text Input Field
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.bottomNavigationColor : const Color(0xFFF7F5F0),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSend(),
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1E3A5F),
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(
                      color: isDark ? AppColors.blueColor.withOpacity(0.6) : const Color(0xFFAAAAAA),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Voice / Send Action Button
            GestureDetector(
              onTap: _isTyping ? _handleSend : widget.onSendAudio,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.bottomNavigationColor : const Color(0xFFFBF6EE),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    _isTyping ? Icons.send : Icons.mic_none_outlined,
                    color: _isTyping ? AppColors.yellowColor : (isDark ? AppColors.blueColor : AppColors.yellowColor),
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
