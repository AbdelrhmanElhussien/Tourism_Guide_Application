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
      final list = await _bookingService.fetchMyBookings();
      // Sort descending (newest bookings first)
      list.sort((a, b) {
        if (a.date == null) return 1;
        if (b.date == null) return -1;
        try {
          final dateA = DateTime.parse(a.date!);
          final dateB = DateTime.parse(b.date!);
          return dateB.compareTo(dateA);
        } catch (_) {
          return 0;
        }
      });
      _bookings = list;
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
      final index = _bookings.indexWhere((booking) => booking.id.toString() == id);
      if (index != -1) {
        final b = _bookings[index];
        _bookings[index] = BookingModel(
          id: b.id,
          userId: b.userId,
          itemId: b.itemId,
          itemType: b.itemType,
          itemName: b.itemName,
          status: 'cancel',
          date: b.date,
          price: b.price,
        );
      }
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

  void clearCache() {
    _bookings = [];
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
