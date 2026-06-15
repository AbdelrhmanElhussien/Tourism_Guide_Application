import 'package:flutter/material.dart';
import 'package:tourist_app/features/explore/models/hotel_model.dart';
import 'package:tourist_app/features/explore/services/hotel_service.dart';

class HotelProvider extends ChangeNotifier {
  final HotelService _hotelService = HotelService();

  List<HotelModel> _hotels = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasFetched = false;

  List<HotelModel> get hotels => _hotels;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isEmpty => _hotels.isEmpty && !_isLoading && !hasError;

  Future<void> fetchHotels({bool forceRefresh = false}) async {
    if (_hasFetched && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _hotels = await _hotelService.fetchHotels();
      _hasFetched = true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearCache() {
    _hasFetched = false;
    _hotels = [];
    _errorMessage = null;
    notifyListeners();
  }
}
