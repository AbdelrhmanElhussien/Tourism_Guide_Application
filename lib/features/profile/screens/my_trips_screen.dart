import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/features/profile/service_provider/screens/my_services_screen.dart'; // import DashedBorderPainter

class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<Themeprovider>(context);
    bool isLight = themeProvider.apptheme == ThemeMode.light;

    return Scaffold(
      backgroundColor: isLight ? const Color(0xffF8FAFC) : AppColors.darkBlueColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isLight ? AppColors.primaryColor : Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.yellowColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 20),
              onPressed: () {},
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'my_trips_title'.tr(),
                style: GoogleFonts.inter(
                  color: isLight ? AppColors.primaryColor : Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'plan_journey'.tr(),
                style: GoogleFonts.inter(
                  color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),

              // Trip Banner Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFC5A352),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ancient_wonders_tour'.tr(),
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'May 1-5, 2026',
                          style: GoogleFonts.inter(color: Colors.white.withOpacity(0.9)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Day 1
              _buildDayHeader('D1', 'Day 1'.tr(), 'May 1', isLight),
              _buildTimelineCard('Pyramids of Giza', '9:00 AM', 'assets/images/ImagePyramidsofGiza.png', isLight),
              _buildTimelineCard('Egyptian Museum', '2:00 PM', null, isLight, networkImage: 'https://images.unsplash.com/photo-1572252009286-268acec5a0af?w=400&q=80'),
              _buildAddActivityButton(isLight),

              const SizedBox(height: 24),

              // Day 2
              _buildDayHeader('D2', 'Day 2'.tr(), 'May 2', isLight),
              _buildTimelineCard('Luxor Temple', '10:00 AM', null, isLight, networkImage: 'https://images.unsplash.com/photo-1601397922721-4326ae07bbc5?w=400&q=80'),
              _buildAddActivityButton(isLight),

              const SizedBox(height: 32),

              // Create New Trip Button
              CustomPaint(
                painter: DashedBorderPainter(
                  color: isLight ? Colors.black.withOpacity(0.15) : Colors.white.withOpacity(0.15),
                  borderRadius: 16.0,
                ),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: isLight ? AppColors.primaryColor : AppColors.blueColor),
                      const SizedBox(width: 8),
                      Text(
                        'create_new_trip'.tr(),
                        style: GoogleFonts.inter(
                          color: isLight ? AppColors.primaryColor : AppColors.blueColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayHeader(String label, String title, String date, bool isLight) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              color: isLight ? AppColors.primaryColor : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            date,
            style: GoogleFonts.inter(
              color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(String title, String time, String? assetImage, bool isLight, {String? networkImage}) {
    return Container(
      margin: const EdgeInsets.only(left: 48, bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : const Color(0xFF162535),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLight ? Colors.black.withOpacity(0.04) : Colors.white.withOpacity(0.04),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 50,
              height: 50,
              child: assetImage != null
                  ? Image.asset(assetImage, fit: BoxFit.cover)
                  : networkImage != null
                      ? Image.network(networkImage, fit: BoxFit.cover)
                      : Container(color: Colors.grey[300], child: const Icon(Icons.image)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.tr(),
                  style: GoogleFonts.inter(
                    color: isLight ? AppColors.primaryColor : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.grey, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddActivityButton(bool isLight) {
    return Container(
      margin: const EdgeInsets.only(left: 48, bottom: 12),
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: isLight ? Colors.black.withOpacity(0.12) : Colors.white.withOpacity(0.12),
          borderRadius: 10.0,
        ),
        child: Container(
          width: double.infinity,
          height: 44,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 16, color: isLight ? AppColors.primaryColor : AppColors.blueColor),
              const SizedBox(width: 6),
              Text(
                'add_activity'.tr(),
                style: GoogleFonts.inter(
                  color: isLight ? AppColors.primaryColor : AppColors.blueColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
