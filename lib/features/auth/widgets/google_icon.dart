import 'package:flutter/material.dart';
import 'package:tourist_app/features/auth/widgets/google_painter.dart';

class GoogleIcon extends StatelessWidget {
  const GoogleIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(painter: GooglePainter()),
    );
  }
}
