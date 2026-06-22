import 'package:flutter/material.dart';
import 'package:tourist_app/features/explore/models/hotel_model.dart';
import 'package:tourist_app/features/explore/services/hotel_service.dart';

class HotelProvider extends ChangeNotifier {
  final HotelService _hotelService = HotelService();

  List<HotelModel> _hotels = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  String? _errorMessage;
  bool _hasFetched = false;
  
  int _currentPage = 1;
  bool _hasMore = true;
  static const int _limit = 10;

  List<HotelModel> get hotels => _hotels;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isEmpty => _hotels.isEmpty && !_isLoading && !hasError;
  bool get hasMore => _hasMore;

  Future<void> fetchHotels({bool forceRefresh = false}) async {
    if (_hasFetched && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();

    try {
      final newItems = await _hotelService.fetchHotels(page: _currentPage, limit: _limit);
      _hotels = newItems;
      _hasFetched = true;
      if (newItems.length < _limit) {
        _hasMore = false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMoreHotels() async {
    if (_isFetchingMore || !_hasMore || _isLoading) return;

    _isFetchingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final newItems = await _hotelService.fetchHotels(page: _currentPage, limit: _limit);
      
      if (newItems.isEmpty) {
        _hasMore = false;
      } else {
        final existingIds = _hotels.map((item) => item.id).toSet();
        final uniqueNewItems = newItems.where((item) => !existingIds.contains(item.id)).toList();
        if (uniqueNewItems.isEmpty) {
          _hasMore = false;
        } else {
          _hotels.addAll(uniqueNewItems);
          if (newItems.length < _limit) {
            _hasMore = false;
          }
        }
      }
    } catch (e) {
      _currentPage--; // Revert page count on error
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  HotelModel? _selectedHotelDetails;
  bool _isLoadingDetails = false;
  String? _errorMessageDetails;

  HotelModel? get selectedHotelDetails => _selectedHotelDetails;
  bool get isLoadingDetails => _isLoadingDetails;
  String? get errorMessageDetails => _errorMessageDetails;

  Future<void> fetchHotelDetails(String id, {bool forceRefresh = false}) async {
    if (_selectedHotelDetails?.id == id && !forceRefresh) return;

    _isLoadingDetails = true;
    _errorMessageDetails = null;
    notifyListeners();

    try {
      final details = await _hotelService.fetchHotelDetails(id);
      _selectedHotelDetails = details;
    } catch (e) {
      _errorMessageDetails = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingDetails = false;
      notifyListeners();
    }
  }

  void clearCache() {
    _hasFetched = false;
    _hotels = [];
    _errorMessage = null;
    _currentPage = 1;
    _hasMore = true;
    _selectedHotelDetails = null;
    _isLoadingDetails = false;
    _errorMessageDetails = null;
    notifyListeners();
  }
}
