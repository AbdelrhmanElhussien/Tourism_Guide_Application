import 'package:flutter/material.dart';

class GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double r = size.width / 2;
    final center = Offset(r, r);

    // Draw coloured arc segments (simplified)
    final segments = [
      (0.0, 0.5, const Color(0xFF4285F4)),   // blue
      (0.5, 1.0, const Color(0xFF34A853)),   // green
      (1.0, 1.5, const Color(0xFFFBBC05)),   // yellow
      (1.5, 2.0, const Color(0xFFEA4335)),   // red
    ];

    for (final seg in segments) {
      final paint = Paint()
        ..color = seg.$3
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.18
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r * 0.72),
        seg.$1 * 3.14159,
        (seg.$2 - seg.$1) * 3.14159,
        false,
        paint,
      );
    }

    // Blue horizontal bar (the G crossbar)
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..strokeWidth = size.width * 0.18
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(r, r),
      Offset(r + r * 0.72, r),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(GooglePainter oldDelegate) => false;
}