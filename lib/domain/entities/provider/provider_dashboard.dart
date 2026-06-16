import 'provider_booking.dart';

class ProviderDashboard {
  final double totalEarnings;
  final String earningsGrowth;
  final int totalBookings;
  final String bookingsGrowth;
  final int thisMonthBookings;
  final String thisMonthGrowth;
  final double rating;
  final String ratingGrowth;
  final List<ProviderBooking> recentBookings;

  ProviderDashboard({
    required this.totalEarnings,
    required this.earningsGrowth,
    required this.totalBookings,
    required this.bookingsGrowth,
    required this.thisMonthBookings,
    required this.thisMonthGrowth,
    required this.rating,
    required this.ratingGrowth,
    required this.recentBookings,
  });
}
