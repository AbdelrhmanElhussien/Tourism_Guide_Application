import 'package:flutter/material.dart';

class Topcircularbutton extends StatelessWidget {
  IconData? icon;
   Topcircularbutton({super.key , this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: const Color(0xFF1D3557), size: 20),
    );
  }
}
