import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_app/core/di/di.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/domain/entities/provider/provider_booking.dart';
import 'package:tourist_app/features/profile/service_provider/cubits/provider_bookings_cubit.dart';
import 'package:tourist_app/features/profile/service_provider/cubits/provider_bookings_states.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  int _selectedTab = 0; // 0: Confirmed, 1: Pending, 2: Past

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<Themeprovider>(context);
    bool isLight = themeProvider.apptheme == ThemeMode.light;
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => getIt<ProviderBookingsCubit>()..fetchBookings(),
      child: BlocConsumer<ProviderBookingsCubit, ProviderBookingsState>(
        listener: (context, state) {
          if (state is ProviderBookingActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ProviderBookingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMsg),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          int totalCount = 0;
          int confirmedCount = 0;
          int pendingCount = 0;
          int pastCount = 0;
          List<ProviderBooking> bookings = [];

          if (state is ProviderBookingsSuccess) {
            bookings = state.bookings;
            totalCount = bookings.length;
            confirmedCount = bookings.where((b) => b.status == "confirmed").length;
            pendingCount = bookings.where((b) => b.status == "pending").length;
            pastCount = bookings.where((b) => b.status == "completed" || b.status == "declined").length;
          }

          return Scaffold(
            backgroundColor: isLight ? const Color(0xffF8FAFC) : AppColors.darkBlueColor,
            body: SafeArea(
              top: false,
              bottom: true,
              child: Column(
                children: [
                  // ── Header Section ──────────────────────────────────────────
                  _buildHeader(context, isLight, size, totalCount),

                  // ── Segmented Tab Selector ──────────────────────────────────
                  _buildTabSelector(isLight, confirmedCount, pendingCount, pastCount),

                  // ── Bookings List Content ───────────────────────────────────
                  Expanded(
                    child: _buildBody(context, isLight, state, bookings),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isLight, Size size, int totalCount) {
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
                Text(
                  "$totalCount ${"total_bookings_count".tr()}",
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

  Widget _buildTabSelector(bool isLight, int confirmedCount, int pendingCount, int pastCount) {
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
          _buildTabItem(0, "${"confirmed_tab".tr()} ($confirmedCount)", isLight),
          _buildTabItem(1, "${"pending_tab".tr()} ($pendingCount)", isLight),
          _buildTabItem(2, "${"past_tab".tr()} ($pastCount)", isLight),
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

  Widget _buildBody(BuildContext context, bool isLight, ProviderBookingsState state, List<ProviderBooking> bookings) {
    if (state is ProviderBookingsLoading || state is ProviderBookingsInitial) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      );
    } else if (state is ProviderBookingsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.errorMsg,
              style: TextStyle(color: isLight ? Colors.black : Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<ProviderBookingsCubit>().fetchBookings();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else {
      List<ProviderBooking> currentBookings = [];
      if (_selectedTab == 0) {
        currentBookings = bookings.where((b) => b.status == "confirmed").toList();
      } else if (_selectedTab == 1) {
        currentBookings = bookings.where((b) => b.status == "pending").toList();
      } else {
        currentBookings = bookings.where((b) => b.status == "completed" || b.status == "declined").toList();
      }

      if (currentBookings.isEmpty) {
        return Center(
          child: Text(
            "no_bookings_found".tr() == "no_bookings_found" ? "No bookings found" : "no_bookings_found".tr(),
            style: TextStyle(color: isLight ? Colors.grey : Colors.white70),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => context.read<ProviderBookingsCubit>().fetchBookings(),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: currentBookings.length,
          itemBuilder: (context, index) {
            final b = currentBookings[index];
            if (_selectedTab == 0) {
              return _buildBookingCard(
                title: b.title,
                customer: b.customerName,
                date: b.date,
                price: "${b.price.toInt()} EGP",
                status: b.status,
                isLight: isLight,
                showActions: true,
                action1Text: "contact".tr(),
                action2Text: "complete".tr(),
                onAction1: () {
                  context.read<ProviderBookingsCubit>().contactBooking(b.id);
                },
                onAction2: () {
                  context.read<ProviderBookingsCubit>().completeBooking(b.id);
                },
              );
            } else if (_selectedTab == 1) {
              return _buildBookingCard(
                title: b.title,
                customer: b.customerName,
                date: b.date,
                price: "${b.price.toInt()} EGP",
                status: b.status,
                isLight: isLight,
                showActions: true,
                action1Text: "decline".tr(),
                action2Text: "confirm".tr(),
                onAction1: () {
                  context.read<ProviderBookingsCubit>().declineBooking(b.id);
                },
                onAction2: () {
                  context.read<ProviderBookingsCubit>().confirmBooking(b.id);
                },
              );
            } else {
              return _buildBookingCard(
                title: b.title,
                customer: b.customerName,
                date: b.date,
                price: "${b.price.toInt()} EGP",
                status: b.status,
                isLight: isLight,
                showActions: false,
              );
            }
          },
        ),
      );
    }
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
    } else if (status == "completed") {
      badgeBgColor = isLight ? const Color(0xFFFDF4E5) : const Color(0x15C9A646);
      badgeTextColor = isLight ? const Color(0xFFB8963E) : const Color(0xFFC9A646);
    } else {
      // declined
      badgeBgColor = isLight ? const Color(0xFFFFECEF) : const Color(0x15FF4D4D);
      badgeTextColor = Colors.red;
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
