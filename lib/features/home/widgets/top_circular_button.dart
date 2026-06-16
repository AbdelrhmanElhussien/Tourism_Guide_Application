import 'package:flutter/material.dart';

class Topcircularbutton extends StatefulWidget {
  final IconData? icon;
  final bool isSelected;
  final VoidCallback fun;
  
  const Topcircularbutton({
    super.key,
    this.icon,
    required this.isSelected,
    required this.fun,
  });

  @override
  State<Topcircularbutton> createState() => _TopcircularbuttonState();
}

class _TopcircularbuttonState extends State<Topcircularbutton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.fun,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          widget.icon,
          color: widget.isSelected
              ? (widget.icon == Icons.favorite ? Colors.red : (widget.icon == Icons.check_circle ? Colors.green : const Color(0xFF1D3557)))
              : const Color(0xFF1D3557),
          size: 20,
        ),
      ),
    );
  }
}
