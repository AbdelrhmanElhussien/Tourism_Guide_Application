import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_colors.dart';

class ServiceProviderScreen extends StatelessWidget {
  const ServiceProviderScreen({super.key});

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
            _buildHeader(context, size),

            // ── Dashboard Content ───────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Stats Grid ---
                    _buildStatsGrid(context, isLight),
                    const SizedBox(height: 20),

                    // --- Action Cards ---
                    _buildActionCards(context, isLight),
                    const SizedBox(height: 24),

                    // --- Recent Bookings ---
                    _buildRecentBookings(context, isLight),
                    const SizedBox(height: 24),

                    // --- View Earnings Banner ---
                    _buildViewEarningsBanner(context),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Size size) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, size.height * 0.06, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
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
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Title
          Text(
            "provider_dashboard".tr(),
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, bool isLight) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context: context,
                iconWidget: Text(
                  '\$',
                  style: GoogleFonts.inter(
                    color: AppColors.yellowColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                iconBgColor: isLight
                    ? const Color(0xFFFEF9EC)
                    : AppColors.yellowColor.withValues(alpha: 0.15),
                title: "total_earnings".tr(),
                value: "5,240 EGP",
                growth: "+12%",
                isLight: isLight,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                context: context,
                iconWidget: const Icon(
                  Icons.people_outline,
                  color: Color(0xFF1ABC9C),
                  size: 20,
                ),
                iconBgColor: isLight
                    ? const Color(0xFFEBF7F5)
                    : const Color(0xFF1ABC9C).withValues(alpha: 0.15),
                title: "total_bookings".tr(),
                value: "156",
                growth: "+8%",
                isLight: isLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context: context,
                iconWidget: Icon(
                  Icons.calendar_month_outlined,
                  color: isLight ? AppColors.primaryColor : AppColors.blueColor,
                  size: 20,
                ),
                iconBgColor: isLight
                    ? const Color(0xFFEEF4F8)
                    : (isLight ? AppColors.primaryColor : AppColors.blueColor).withValues(alpha: 0.15),
                title: "this_month".tr(),
                value: "23",
                growth: "+15%",
                isLight: isLight,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                context: context,
                iconWidget: const Icon(
                  Icons.trending_up,
                  color: AppColors.yellowColor,
                  size: 20,
                ),
                iconBgColor: isLight
                    ? const Color(0xFFFEF9EC)
                    : AppColors.yellowColor.withValues(alpha: 0.15),
                title: "rating".tr(),
                value: "4.8",
                growth: "+0.2",
                isLight: isLight,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required Widget iconWidget,
    required Color iconBgColor,
    required String title,
    required String value,
    required String growth,
    required bool isLight,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: iconWidget,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              color: isLight ? const Color(0xFF64748B) : AppColors.blueColor,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              color: isLight ? AppColors.primaryColor : AppColors.whiteColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            growth,
            style: GoogleFonts.inter(
              color: const Color(0xFF10B981),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCards(BuildContext context, bool isLight) {
    return Row(
      children: [
        // Add Service Card
        Expanded(
          child: Container(
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.yellowColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.yellowColor.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 26,
                      ),
                      Text(
                        "add_service".tr(),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // My Services Card
        Expanded(
          child: Container(
            height: 96,
            decoration: BoxDecoration(
              color: isLight ? AppColors.whiteColor : AppColors.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isLight
                    ? Colors.black.withValues(alpha: 0.05)
                    : AppColors.blueColor.withValues(alpha: 0.08),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        color: isLight ? AppColors.primaryColor : AppColors.blueColor,
                        size: 22,
                      ),
                      Text(
                        "my_services".tr(),
                        style: GoogleFonts.inter(
                          color: isLight ? AppColors.primaryColor : AppColors.whiteColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentBookings(BuildContext context, bool isLight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "recent_bookings".tr(),
              style: GoogleFonts.inter(
                color: isLight ? AppColors.primaryColor : AppColors.whiteColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                "see_all".tr(),
                style: GoogleFonts.inter(
                  color: AppColors.yellowColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isLight ? AppColors.whiteColor : AppColors.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isLight
                  ? Colors.black.withValues(alpha: 0.05)
                  : AppColors.blueColor.withValues(alpha: 0.08),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildBookingItem(
                title: "Pyramids Tour",
                customer: "Sarah Johnson",
                date: "Apr 30",
                status: "confirmed",
                isLight: isLight,
              ),
              _buildBookingItem(
                title: "Nile Cruise",
                customer: "Mike Chen",
                date: "May 2",
                status: "pending",
                isLight: isLight,
              ),
              _buildBookingItem(
                title: "Temple Visit",
                customer: "Emma Wilson",
                date: "May 5",
                status: "confirmed",
                isLight: isLight,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingItem({
    required String title,
    required String customer,
    required String date,
    required String status,
    required bool isLight,
  }) {
    bool isConfirmed = status == "confirmed";
    Color badgeBgColor = isConfirmed
        ? (isLight ? const Color(0xFFE6F7F0) : const Color(0x151ABC9C))
        : (isLight ? const Color(0xFFFEF9EC) : const Color(0x15C9A646));
    Color badgeTextColor = isConfirmed
        ? (isLight ? const Color(0xFF1ABC9C) : const Color(0xFF1ABC9C))
        : (isLight ? AppColors.yellowColor : AppColors.yellowColor);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isLight ? const Color(0xFFF8FAFC) : Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: isLight ? AppColors.primaryColor : AppColors.whiteColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                customer,
                style: GoogleFonts.inter(
                  color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          // Right Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                date,
                style: GoogleFonts.inter(
                  color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status.tr(),
                  style: GoogleFonts.inter(
                    color: badgeTextColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewEarningsBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.yellowColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.yellowColor.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "view_earnings".tr(),
                style: GoogleFonts.inter(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "5,240 EGP",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.trending_up,
            color: Colors.white,
            size: 36,
          ),
        ],
      ),
    );
  }
}
