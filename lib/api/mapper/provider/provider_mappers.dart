import 'package:tourist_app/api/model/response/provider/provider_booking_dto.dart';
import 'package:tourist_app/api/model/response/provider/provider_dashboard_dto.dart';
import 'package:tourist_app/api/model/response/provider/provider_earnings_dto.dart';
import 'package:tourist_app/api/model/response/provider/provider_service_dto.dart';
import 'package:tourist_app/domain/entities/provider/provider_booking.dart';
import 'package:tourist_app/domain/entities/provider/provider_dashboard.dart';
import 'package:tourist_app/domain/entities/provider/provider_earnings.dart';
import 'package:tourist_app/domain/entities/provider/provider_service.dart';

extension ProviderServiceDtoMapper on ProviderServiceDto {
  ProviderService toProviderService() {
    return ProviderService(
      id: id ?? '',
      title: title ?? '',
      category: category ?? '',
      price: price ?? 0.0,
      bookingsCount: bookingsCount ?? 0,
      rating: rating ?? 0.0,
      imageUrl: imageUrl ?? '',
      duration: duration ?? '',
      location: location ?? '',
      description: description ?? '',
      availability: availability ?? [],
      placeId: placeId ?? '',
    );
  }
}

extension ProviderBookingDtoMapper on ProviderBookingDto {
  ProviderBooking toProviderBooking() {
    return ProviderBooking(
      id: id ?? '',
      title: title ?? '',
      customerName: customerName ?? '',
      date: date ?? '',
      price: price ?? 0.0,
      status: status ?? 'pending',
    );
  }
}

extension ProviderDashboardDtoMapper on ProviderDashboardDto {
  ProviderDashboard toProviderDashboard() {
    return ProviderDashboard(
      totalEarnings: totalEarnings ?? 0.0,
      earningsGrowth: earningsGrowth ?? '',
      totalBookings: totalBookings ?? 0,
      bookingsGrowth: bookingsGrowth ?? '',
      thisMonthBookings: thisMonthBookings ?? 0,
      thisMonthGrowth: thisMonthGrowth ?? '',
      rating: rating ?? 0.0,
      ratingGrowth: ratingGrowth ?? '',
      recentBookings: recentBookings?.map((b) => b.toProviderBooking()).toList() ?? [],
    );
  }
}

extension ProviderEarningsDtoMapper on ProviderEarningsDto {
  ProviderEarnings toProviderEarnings() {
    return ProviderEarnings(
      totalEarnings: totalEarnings ?? 0.0,
      earningsGrowth: earningsGrowth ?? '',
      monthlyOverview: monthlyOverview ?? [],
      recentTransactions: recentTransactions?.map((t) => t.toProviderTransaction()).toList() ?? [],
    );
  }
}

extension ProviderTransactionDtoMapper on ProviderTransactionDto {
  ProviderTransaction toProviderTransaction() {
    return ProviderTransaction(
      title: title ?? '',
      date: date ?? '',
      amount: amount ?? 0.0,
      isCredit: isCredit ?? true,
    );
  }
}
