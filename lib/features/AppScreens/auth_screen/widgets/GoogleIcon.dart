import 'package:flutter/material.dart';
import 'package:tourist_app/features/AppScreens/auth_screen/widgets/GooglePainter.dart';

class GoogleIcon extends StatelessWidget {
  const GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(painter: GooglePainter()),
    );
  }

}
