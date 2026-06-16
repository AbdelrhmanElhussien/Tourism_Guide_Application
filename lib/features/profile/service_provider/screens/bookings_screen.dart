import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';

import 'package:tourist_app/features/booking/provider/booking_provider.dart';
import 'package:tourist_app/core/utils/dialoge_utils.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  int _selectedTab = 0; // 0: Confirmed, 1: Pending, 2: Past

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().fetchMyBookings();
    });
  }

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

            // ── Segmented Tab Selector ──────────────────────────────────
            _buildTabSelector(isLight),

            // ── Bookings List Content ───────────────────────────────────
            Expanded(
              child: _buildBookingsList(isLight),
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
                ? Colors.black.withOpacity(0.05)
                : Colors.white.withOpacity(0.05),
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
                    ? Colors.black.withOpacity(0.05)
                    : Colors.white.withOpacity(0.1),
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
                  "bookings_title".tr(),
                  style: GoogleFonts.inter(
                    color: isLight ? AppColors.primaryColor : Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Consumer<BookingProvider>(
                  builder: (context, provider, child) {
                    return Text(
                      "${provider.bookings.length} ${"total_bookings_count".tr()}",
                      style: GoogleFonts.inter(
                        color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector(bool isLight) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isLight ? const Color(0xFFF1F5F9) : AppColors.bottomNavigationColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTabItem(0, "${"confirmed_tab".tr()} (2)", isLight),
          _buildTabItem(1, "${"pending_tab".tr()} (1)", isLight),
          _buildTabItem(2, "${"past_tab".tr()} (1)", isLight),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String label, bool isLight) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? (isLight ? Colors.white : const Color(0xFF1E2F46))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected && isLight
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: isSelected
                  ? (isLight ? AppColors.primaryColor : Colors.white)
                  : (isLight ? AppColors.lightGrayColor : AppColors.blueColor),
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingsList(bool isLight) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) {
        if (bookingProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.yellowColor),
          );
        }

        if (bookingProvider.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 50, color: Colors.red),
                const SizedBox(height: 16),
                Text(bookingProvider.errorMessage ?? 'Error', style: TextStyle(color: isLight ? Colors.black : Colors.white)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => bookingProvider.fetchMyBookings(forceRefresh: true),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.yellowColor),
                  child: Text('retry'.tr(), style: const TextStyle(color: Colors.white)),
                )
              ],
            ),
          );
        }

        final bookings = bookingProvider.bookings;

        if (bookings.isEmpty) {
          return Center(
            child: Text(
              'No bookings found',
              style: TextStyle(color: isLight ? Colors.grey : Colors.white54, fontSize: 16),
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.yellowColor,
          onRefresh: () => bookingProvider.fetchMyBookings(forceRefresh: true),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return _buildBookingCard(
                title: booking.itemName ?? 'Unknown Item',
                customer: 'User ${booking.userId ?? ''}',
                date: booking.date ?? '',
                price: booking.price != null ? '${booking.price} EGP' : 'N/A',
                status: booking.status ?? 'pending',
                isLight: isLight,
                showActions: true,
                action1Text: 'Delete',
                action2Text: 'Details',
                onAction1: () async {
                  if (booking.id != null) {
                    try {
                      DialogeUtils.showLoading(context: context, text: "loading_msg".tr());
                      await context.read<BookingProvider>().deleteBooking(booking.id!.toString());
                      DialogeUtils.hideLoading(context: context);
                      DialogeUtils.showMassage(context: context, masseage: 'Deleted Successfully', title: 'Success', posActionName: 'OK');
                    } catch (e) {
                      DialogeUtils.hideLoading(context: context);
                      DialogeUtils.showMassage(context: context, masseage: e.toString(), title: 'Error', posActionName: 'OK');
                    }
                  }
                },
                onAction2: () {},
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBookingCard({
    required String title,
    required String customer,
    required String date,
    required String price,
    required String status,
    required bool isLight,
    required bool showActions,
    String? action1Text,
    String? action2Text,
    VoidCallback? onAction1,
    VoidCallback? onAction2,
  }) {
    Color badgeBgColor;
    Color badgeTextColor;

    if (status == "confirmed") {
      badgeBgColor = isLight ? const Color(0xFFE6F7F0) : const Color(0x151ABC9C);
      badgeTextColor = const Color(0xFF1ABC9C);
    } else if (status == "pending") {
      badgeBgColor = isLight ? const Color(0xFFFEF9EC) : const Color(0x15C9A646);
      badgeTextColor = AppColors.yellowColor;
    } else {
      // completed
      badgeBgColor = isLight ? const Color(0xFFFDF4E5) : const Color(0x15C9A646);
      badgeTextColor = isLight ? const Color(0xFFB8963E) : const Color(0xFFC9A646);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isLight ? AppColors.whiteColor : AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isLight
              ? Colors.black.withOpacity(0.05)
              : AppColors.blueColor.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.inter(
                          color: isLight ? AppColors.primaryColor : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                const SizedBox(height: 16),

                // Customer Info Row
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        customer,
                        style: GoogleFonts.inter(
                          color: isLight ? const Color(0xFF64748B) : AppColors.blueColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Date Info Row
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        date,
                        style: GoogleFonts.inter(
                          color: isLight ? const Color(0xFF64748B) : AppColors.blueColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Price Info Row
                Row(
                  children: [
                    Text(
                      r"$",
                      style: GoogleFonts.inter(
                        color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        price,
                        style: GoogleFonts.inter(
                          color: isLight ? AppColors.primaryColor : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Actions
          if (showActions && action1Text != null && action2Text != null) ...[
            Divider(
              height: 1,
              thickness: 0.5,
              color: isLight
                  ? Colors.black.withOpacity(0.05)
                  : Colors.white.withOpacity(0.05),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                children: [
                  // Action 1 (Border style button)
                  Expanded(
                    child: InkWell(
                      onTap: onAction1,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isLight
                                ? Colors.black.withOpacity(0.1)
                                : Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          action1Text,
                          style: GoogleFonts.inter(
                            color: isLight ? AppColors.primaryColor : Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Action 2 (Filled gold style button)
                  Expanded(
                    child: InkWell(
                      onTap: onAction2,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.yellowColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.yellowColor.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          action2Text,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
