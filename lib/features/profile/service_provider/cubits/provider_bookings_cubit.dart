import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:tourist_app/core/exceptions/app_exception.dart';
import 'package:tourist_app/domain/use_cases/provider/provider_use_cases.dart';
import 'provider_bookings_states.dart';

@injectable
class ProviderBookingsCubit extends Cubit<ProviderBookingsState> {
  final GetProviderBookingsUseCase _getBookingsUseCase;
  final ConfirmBookingUseCase _confirmBookingUseCase;
  final DeclineBookingUseCase _declineBookingUseCase;
  final CompleteBookingUseCase _completeBookingUseCase;
  final ContactBookingUseCase _contactBookingUseCase;

  ProviderBookingsCubit(
    this._getBookingsUseCase,
    this._confirmBookingUseCase,
    this._declineBookingUseCase,
    this._completeBookingUseCase,
    this._contactBookingUseCase,
  ) : super(ProviderBookingsInitial());

  String _getErrorMessage(dynamic e) {
    String msg = e.toString();
    if (e is DioException) {
      if (e.error is AppException) {
        msg = (e.error as AppException).message;
      } else {
        msg = e.message ?? msg;
      }
    } else if (e is AppException) {
      msg = e.message;
    }
    return msg;
  }

  Future<void> fetchBookings() async {
    try {
      emit(ProviderBookingsLoading());
      final bookings = await _getBookingsUseCase.invoke();
      emit(ProviderBookingsSuccess(bookings: bookings));
    } catch (e) {
      emit(ProviderBookingsError(errorMsg: _getErrorMessage(e)));
    }
  }

  Future<void> confirmBooking(String id) async {
    try {
      emit(ProviderBookingsLoading());
      await _confirmBookingUseCase.invoke(id);
      emit(ProviderBookingActionSuccess(message: "Booking confirmed successfully!"));
      await fetchBookings();
    } catch (e) {
      emit(ProviderBookingsError(errorMsg: _getErrorMessage(e)));
    }
  }

  Future<void> declineBooking(String id) async {
    try {
      emit(ProviderBookingsLoading());
      await _declineBookingUseCase.invoke(id);
      emit(ProviderBookingActionSuccess(message: "Booking declined successfully!"));
      await fetchBookings();
    } catch (e) {
      emit(ProviderBookingsError(errorMsg: _getErrorMessage(e)));
    }
  }

  Future<void> completeBooking(String id) async {
    try {
      emit(ProviderBookingsLoading());
      await _completeBookingUseCase.invoke(id);
      emit(ProviderBookingActionSuccess(message: "Booking completed successfully!"));
      await fetchBookings();
    } catch (e) {
      emit(ProviderBookingsError(errorMsg: _getErrorMessage(e)));
    }
  }

  Future<void> contactBooking(String id) async {
    try {
      await _contactBookingUseCase.invoke(id);
      emit(ProviderBookingActionSuccess(message: "Contact initialized!"));
    } catch (e) {
      emit(ProviderBookingsError(errorMsg: _getErrorMessage(e)));
    }
  }
}
