import 'package:flutter/material.dart';
import 'package:tourist_app/core/utils/app_theme.dart';

class Customebotton extends StatelessWidget {
  String text;
  Color backgroundColor;
  TextStyle? style;
  VoidCallback? onPressed;
  Customebotton(
      {super.key,
        required this.text,
        required this.backgroundColor,
        this.onPressed,
        this.style
      }
      );

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(vertical: size.height * 0.008),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(text, style:style),
    );
  }
}
