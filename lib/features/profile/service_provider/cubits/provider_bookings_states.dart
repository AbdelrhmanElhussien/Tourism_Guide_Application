import 'package:tourist_app/domain/entities/provider/provider_booking.dart';

sealed class ProviderBookingsState {}

class ProviderBookingsInitial extends ProviderBookingsState {}

class ProviderBookingsLoading extends ProviderBookingsState {}

class ProviderBookingsSuccess extends ProviderBookingsState {
  final List<ProviderBooking> bookings;
  ProviderBookingsSuccess({required this.bookings});
}

class ProviderBookingActionSuccess extends ProviderBookingsState {
  final String message;
  ProviderBookingActionSuccess({required this.message});
}

class ProviderBookingsError extends ProviderBookingsState {
  final String errorMsg;
  ProviderBookingsError({required this.errorMsg});
}
