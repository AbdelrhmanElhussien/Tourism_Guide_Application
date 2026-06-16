import 'package:flutter/material.dart';
import 'package:tourist_app/features/booking/models/booking_model.dart';
import 'package:tourist_app/features/booking/services/booking_service.dart';

class BookingProvider extends ChangeNotifier {
  final BookingService _bookingService = BookingService();

  List<BookingModel> _bookings = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isEmpty => _bookings.isEmpty && !_isLoading && !hasError;

  Future<void> fetchMyBookings({bool forceRefresh = false}) async {
    if (_bookings.isNotEmpty && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _bookings = await _bookingService.fetchMyBookings();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteBooking(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _bookingService.deleteBooking(id);
      _bookings.removeWhere((booking) => booking.id.toString() == id);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      throw Exception(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> bookItem(String type, String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _bookingService.bookItem(type, id);
      // Auto refresh my bookings after successful book
      await fetchMyBookings(forceRefresh: true);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      throw Exception(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
