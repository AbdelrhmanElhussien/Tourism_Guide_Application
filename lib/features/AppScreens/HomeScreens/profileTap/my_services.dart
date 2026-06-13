import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_assets.dart';
import 'package:tourist_app/core/utils/app_colors.dart';

class MyServicesScreen extends StatelessWidget {
  const MyServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<Themeprovider>(context);
    bool isLight = themeProvider.apptheme == ThemeMode.light;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: isLight ? const Color(0xffF8FAFC) : AppColors.darkBlueColor,
      body: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: [
            // ── Header Section ──────────────────────────────────────────
            _buildHeader(context, isLight, size),

            // ── Services List Content ───────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Card 1: Private Pyramids Tour
                  _buildServiceCard(
                    context: context,
                    title: "Private Pyramids Tour",
                    category: "Tour",
                    price: "500 EGP",
                    bookings: "45 ${"bookings".tr()}",
                    rating: 4.9,
                    assetImage: AppAssets.pyramidsofGiza,
                    networkImage: null,
                    isLight: isLight,
                  ),

                  // Card 2: Nile Sunset Cruise
                  _buildServiceCard(
                    context: context,
                    title: "Nile Sunset Cruise",
                    category: "Experience",
                    price: "350 EGP",
                    bookings: "32 ${"bookings".tr()}",
                    rating: 4.8,
                    assetImage: null,
                    networkImage: "https://images.unsplash.com/photo-1572021335469-31706a17aaef?w=400&q=80",
                    isLight: isLight,
                  ),

                  // Card 3: Luxor Temple Visit
                  _buildServiceCard(
                    context: context,
                    title: "Luxor Temple Visit",
                    category: "Tour",
                    price: "400 EGP",
                    bookings: "28 ${"bookings".tr()}",
                    rating: 4.7,
                    assetImage: null,
                    networkImage: "https://images.unsplash.com/photo-1600577916048-804c9191e36c?w=400&q=80",
                    isLight: isLight,
                  ),

                  const SizedBox(height: 8),

                  // --- Add New Service Dotted Button ---
                  CustomPaint(
                    painter: DashedBorderPainter(
                      color: isLight
                          ? Colors.black.withValues(alpha: 0.15)
                          : Colors.white.withValues(alpha: 0.15),
                      borderRadius: 16.0,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      alignment: Alignment.center,
                      child: Text(
                        "+ ${"add_new_service".tr()}",
                        style: GoogleFonts.inter(
                          color: isLight ? AppColors.primaryColor : AppColors.blueColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isLight, Size size) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, size.height * 0.06, 20, 20),
      decoration: BoxDecoration(
        color: isLight ? AppColors.whiteColor : AppColors.darkBlueColor,
        border: Border(
          bottom: BorderSide(
            color: isLight
                ? Colors.black.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Back button
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isLight
                    ? Colors.black.withValues(alpha: 0.05)
                    : Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back,
                color: isLight ? AppColors.primaryColor : Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Titles Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "my_services".tr(),
                  style: GoogleFonts.inter(
                    color: isLight ? AppColors.primaryColor : Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "3 ${"services_listed_count".tr()}",
                  style: GoogleFonts.inter(
                    color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required BuildContext context,
    required String title,
    required String category,
    required String price,
    required String bookings,
    required double rating,
    required String? assetImage,
    required String? networkImage,
    required bool isLight,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isLight ? AppColors.whiteColor : AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isLight
              ? Colors.black.withValues(alpha: 0.05)
              : AppColors.blueColor.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Top Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: assetImage != null
                        ? Image.asset(
                            assetImage,
                            fit: BoxFit.cover,
                          )
                        : networkImage != null
                            ? Image.network(
                                networkImage,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: isLight ? const Color(0xFFF1F3F6) : Colors.white12,
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
                                      size: 20,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: isLight ? const Color(0xFFF1F3F6) : Colors.white12,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.image,
                                  color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
                                  size: 20,
                                ),
                              ),
                  ),
                ),
                const SizedBox(width: 16),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: GoogleFonts.inter(
                                color: isLight ? AppColors.primaryColor : AppColors.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.more_vert,
                            color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category,
                        style: GoogleFonts.inter(
                          color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            price,
                            style: GoogleFonts.inter(
                              color: AppColors.yellowColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              bookings,
                              style: GoogleFonts.inter(
                                color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.star,
                            color: AppColors.yellowColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: GoogleFonts.inter(
                              color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Divider
          Divider(
            height: 1,
            thickness: 0.5,
            color: isLight
                ? Colors.black.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.05),
          ),
          // Actions Row
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {},
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          color: isLight ? AppColors.primaryColor : AppColors.blueColor,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "edit".tr(),
                          style: GoogleFonts.inter(
                            color: isLight ? AppColors.primaryColor : AppColors.blueColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 0.5,
                height: 44,
                color: isLight
                    ? Colors.black.withValues(alpha: 0.05)
                    : Colors.white.withValues(alpha: 0.05),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {},
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "delete".tr(),
                          style: GoogleFonts.inter(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 4.0,
    this.dashLength = 6.0,
    this.borderRadius = 16.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ));

    // Draw dashed path
    final dashPath = Path();
    double distance = 0.0;
    for (final metric in path.computeMetrics()) {
      while (distance < metric.length) {
        final isDash = (distance ~/ dashLength) % 2 == 0;
        if (isDash) {
          dashPath.addPath(
            metric.extractPath(distance, distance + dashLength),
            Offset.zero,
          );
        }
        distance += dashLength;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gap != gap ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.borderRadius != borderRadius;
  }
}
