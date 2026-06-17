import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/core/utils/app_routes.dart';
import 'package:tourist_app/features/booking/models/booking_model.dart';
import 'package:tourist_app/features/booking/provider/booking_provider.dart';
import 'package:tourist_app/features/home/screens/detailed_screen.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().fetchMyBookings(forceRefresh: true);
    });
  }

  Widget _buildFilterChip(String value, String label, bool isLight) {
    final isSelected = selectedFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            selectedFilter = value;
          });
        }
      },
      selectedColor: AppColors.primaryColor,
      backgroundColor: isLight ? Colors.grey[200] : const Color(0xFF1E2E3E),
      labelStyle: GoogleFonts.inter(
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? Colors.white : (isLight ? Colors.black87 : Colors.white70),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? AppColors.primaryColor
              : (isLight ? Colors.grey[300]! : Colors.white.withOpacity(0.08)),
        ),
      ),
      showCheckmark: false,
    );
  }

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
      ),
      body: SafeArea(
        child: Consumer<BookingProvider>(
          builder: (context, bookingProvider, child) {
            if (bookingProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              );
            }

            if (bookingProvider.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
                      const SizedBox(height: 16),
                      Text(
                        bookingProvider.errorMessage ?? 'Something went wrong',
                        style: GoogleFonts.inter(
                          color: isLight ? Colors.black : Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          bookingProvider.fetchMyBookings(forceRefresh: true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('retry'.tr() == 'retry' ? 'Retry' : 'retry'.tr()),
                      ),
                    ],
                  ),
                ),
              );
            }

            final allBookings = bookingProvider.bookings;

            if (allBookings.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bookmark_border_outlined,
                        size: 80,
                        color: isLight ? AppColors.lightGrayColor : AppColors.blueColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'no_bookings_found'.tr(),
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isLight ? AppColors.primaryColor : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'book_explore_subtitle'.tr(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final bookings = allBookings.where((booking) {
              if (selectedFilter == 'All') return true;
              final type = booking.itemType?.toLowerCase() ?? '';
              if (selectedFilter == 'Transportation') {
                return type == 'transport' || type == 'transportation';
              }
              return type == selectedFilter.toLowerCase();
            }).toList();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'my_bookings_title'.tr(),
                    style: GoogleFonts.inter(
                      color: isLight ? AppColors.primaryColor : Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _buildFilterChip('All', 'all'.tr() == 'all' ? 'All' : 'all'.tr(), isLight),
                        const SizedBox(width: 8),
                        _buildFilterChip('Guide', 'guide'.tr() == 'guide' ? 'Guide' : 'guide'.tr(), isLight),
                        const SizedBox(width: 8),
                        _buildFilterChip('Transportation', 'transportation'.tr() == 'transportation' ? 'Transportation' : 'transportation'.tr(), isLight),
                        const SizedBox(width: 8),
                        _buildFilterChip('Hotel', 'hotel'.tr() == 'hotel' ? 'Hotel' : 'hotel'.tr(), isLight),
                        const SizedBox(width: 8),
                        _buildFilterChip('Program', 'program'.tr() == 'program' ? 'Program' : 'program'.tr(), isLight),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: bookings.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40.0),
                              child: Text(
                                'no_bookings_found'.tr(),
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: bookings.length,
                            itemBuilder: (context, index) {
                              final booking = bookings[index];
                              return _buildBookingCard(context, booking, isLight);
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, BookingModel booking, bool isLight) {
    // Determine category styling and icon
    IconData iconData = Icons.bookmark_outline;
    Color iconColor = AppColors.yellowColor;
    Color iconBgColor = const Color(0xFFFEF9EC);
    String typeLabel = booking.itemType ?? 'Booking';

    switch (typeLabel.toLowerCase()) {
      case 'hotel':
        iconData = Icons.hotel_outlined;
        iconColor = const Color(0xFF1ABC9C);
        iconBgColor = const Color(0xFFEBF7F5);
        typeLabel = 'hotel'.tr();
        break;
      case 'transport':
      case 'transportation':
        iconData = Icons.directions_car_outlined;
        iconColor = Colors.orange;
        iconBgColor = const Color(0xFFFFF3E0);
        typeLabel = 'transportation'.tr();
        break;
      case 'guide':
        iconData = Icons.explore_outlined;
        iconColor = Colors.purple;
        iconBgColor = const Color(0xFFF3E5F5);
        typeLabel = 'guide'.tr();
        break;
      case 'program':
        iconData = Icons.event_note_outlined;
        iconColor = Colors.blue;
        iconBgColor = const Color(0xFFE3F2FD);
        typeLabel = 'program'.tr();
        break;
    }

    // Determine Status color
    Color statusColor = Colors.grey;
    String statusText = booking.status ?? 'Pending';
    switch (statusText.toLowerCase()) {
      case 'confirmed':
      case 'approved':
        statusColor = Colors.green;
        statusText = 'confirmed'.tr() == 'confirmed' ? 'Confirmed' : 'confirmed'.tr();
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusText = 'pending'.tr() == 'pending' ? 'Pending' : 'pending'.tr();
        break;
      case 'completed':
        statusColor = Colors.blue;
        statusText = 'completed'.tr() == 'completed' ? 'Completed' : 'completed'.tr();
        break;
    }

    return GestureDetector(
      onTap: () {
        if (booking.itemId == null) return;
        Navigator.pushNamed(
          context,
          AppRoutes.DetailScreenRouteName,
          arguments: DetailArgs(
            id: booking.itemId,
            type: _getDetailType(booking.itemType),
            title: booking.itemName ?? '',
            location: '',
            rating: 0.0,
            reviewsCount: 0,
            about: '',
            price: booking.price != null ? "${booking.price!.toInt()} EGP" : null,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isLight ? Colors.white : const Color(0xFF162535),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isLight ? Colors.black.withOpacity(0.04) : Colors.white.withOpacity(0.04),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Box
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isLight ? iconBgColor : iconColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: isLight ? iconColor : iconColor.withOpacity(0.85),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Info Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Category Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isLight ? iconBgColor : iconColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          typeLabel.toUpperCase(),
                          style: GoogleFonts.inter(
                            color: isLight ? iconColor : iconColor.withOpacity(0.9),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          statusText,
                          style: GoogleFonts.inter(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    booking.itemName ?? 'Unnamed Booking',
                    style: GoogleFonts.inter(
                      color: isLight ? AppColors.primaryColor : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (booking.date != null)
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          _formatDate(booking.date!),
                          style: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (booking.price != null)
                        Text(
                          "${booking.price!.toInt()} EGP",
                          style: GoogleFonts.inter(
                            color: AppColors.yellowColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      IconButton(
                        icon: const Icon(Icons.delete_forever_outlined, color: Colors.redAccent, size: 22),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          _showCancelConfirmation(context, booking.id.toString());
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DetailType _getDetailType(String? type) {
    switch (type?.toLowerCase()) {
      case 'hotel':
        return DetailType.hotel;
      case 'transport':
      case 'transportation':
        return DetailType.transport;
      case 'guide':
        return DetailType.guide;
      case 'program':
        return DetailType.program;
      default:
        return DetailType.place;
    }
  }

  String _formatDate(String rawDate) {
    try {
      final parsed = DateTime.parse(rawDate);
      return DateFormat('dd MMM yyyy, hh:mm a').format(parsed);
    } catch (_) {
      return rawDate;
    }
  }

  void _showCancelConfirmation(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('cancel_booking'.tr()),
          content: Text('cancel_booking_confirm'.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('cancel_action'.tr() == 'cancel_action' ? 'Cancel' : 'cancel_action'.tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<BookingProvider>().deleteBooking(bookingId).catchError((err) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(err.toString().replaceAll('Exception: ', '')),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                });
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('yes_action'.tr() == 'yes_action' ? 'Yes' : 'yes_action'.tr()),
            ),
          ],
        );
      },
    );
  }
}
