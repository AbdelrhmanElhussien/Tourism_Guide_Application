import 'package:flutter/material.dart';
import 'package:tourist_app/features/booking/models/booking_model.dart';
import 'package:tourist_app/features/booking/services/booking_service.dart';
import 'dart:convert';
import 'package:tourist_app/core/utils/cache_helper.dart';

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

  List<BookingModel> _getLocalCancelledBookings() {
    try {
      final jsonStr = CacheHelper.getData(key: 'local_cancelled_bookings');
      if (jsonStr != null && jsonStr is String) {
        final List<dynamic> decoded = jsonDecode(jsonStr);
        return decoded.map((item) => BookingModel.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      debugPrint('Error reading local cancelled bookings: $e');
    }
    return [];
  }

  void _saveLocalCancelledBookings(List<BookingModel> list) {
    try {
      final jsonStr = jsonEncode(list.map((item) => item.toJson()).toList());
      CacheHelper.saveData(key: 'local_cancelled_bookings', value: jsonStr);
    } catch (e) {
      debugPrint('Error saving local cancelled bookings: $e');
    }
  }

  Future<void> fetchMyBookings({bool forceRefresh = false}) async {
    if (_bookings.isNotEmpty && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final list = await _bookingService.fetchMyBookings();
      
      // Load locally cancelled bookings and merge
      final localCancelled = _getLocalCancelledBookings();
      for (final cb in localCancelled) {
        if (!list.any((item) => item.id == cb.id)) {
          list.add(cb);
        }
      }

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
        final cancelledBooking = BookingModel(
          id: b.id,
          userId: b.userId,
          itemId: b.itemId,
          itemType: b.itemType,
          itemName: b.itemName,
          status: 'cancelled_by_user',
          date: b.date,
          price: b.price,
        );
        _bookings[index] = cancelledBooking;

        // Save to local cancelled list
        final localCancelled = _getLocalCancelledBookings();
        localCancelled.removeWhere((item) => item.id == b.id);
        localCancelled.add(cancelledBooking);
        _saveLocalCancelledBookings(localCancelled);
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      throw Exception(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> bookItem(String type, String id, {Map<String, dynamic>? data}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _bookingService.bookItem(type, id, data: data);
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
