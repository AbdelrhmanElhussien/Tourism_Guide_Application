import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final String label;

  const SocialButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFE0E0E0)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
