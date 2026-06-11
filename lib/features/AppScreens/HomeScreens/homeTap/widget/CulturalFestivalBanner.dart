import 'package:flutter/material.dart';

class CulturalFestivalBanner extends StatelessWidget {
  const CulturalFestivalBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = (size.width * 0.055).clamp(18.0, 24.0);
    final titleSize = (size.width * 0.055).clamp(19.0, 22.0);
    final bodySize = (size.width * 0.04).clamp(14.0, 16.0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: const Color(0xFFC5A352),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Cultural Festival',
            style: TextStyle(
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Experience authentic Egyptian traditions and celebrations',
            style: TextStyle(
              color: Colors.white,
              fontSize: bodySize,
              height: 1.4,
            ),
          ),
          SizedBox(height: (size.height * 0.025).clamp(18.0, 24.0)),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFC5A352),
              elevation: 0,
              padding: EdgeInsets.symmetric(
                horizontal: (size.width * 0.055).clamp(18.0, 24.0),
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              'Explore Events',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
