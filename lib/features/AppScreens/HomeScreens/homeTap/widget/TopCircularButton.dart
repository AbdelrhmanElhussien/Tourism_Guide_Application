import 'package:flutter/material.dart';

class Topcircularbutton extends StatefulWidget {
  IconData? icon;
  bool isSelected;
  VoidCallback fun;
   Topcircularbutton({super.key , this.icon , required this.isSelected ,required this.fun});

  @override
  State<Topcircularbutton> createState() => _TopcircularbuttonState();
}

class _TopcircularbuttonState extends State<Topcircularbutton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>widget.fun ,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(widget.icon, color: const Color(0xFF1D3557), size: 20),
      ),
    );
  }
}
