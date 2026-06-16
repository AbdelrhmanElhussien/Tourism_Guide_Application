import 'package:flutter/material.dart';
import 'package:tourist_app/features/home/models/place_model.dart';
import 'package:tourist_app/features/home/services/place_service.dart';

class PlaceProvider extends ChangeNotifier {
  final PlaceService _placeService = PlaceService();

  // All Places List (with Pagination)
  List<PlaceModel> _places = [];
  bool _isLoadingPlaces = false;
  bool _isFetchingMorePlaces = false;
  String? _errorMessagePlaces;
  bool _hasFetchedPlaces = false;
  int _currentPlacesPage = 1;
  bool _hasMorePlaces = true;
  static const int _limit = 10;

  // Recommended Places
  List<PlaceModel> _recommendedPlaces = [];
  bool _isLoadingRecommended = false;
  String? _errorMessageRecommended;
  bool _hasFetchedRecommended = false;

  // Places Summary
  List<PlaceModel> _summaryPlaces = [];
  bool _isLoadingSummary = false;
  String? _errorMessageSummary;
  bool _hasFetchedSummary = false;

  // Place Details
  final Map<String, PlaceModel> _placeDetailsCache = {};
  bool _isLoadingDetails = false;
  String? _errorMessageDetails;
  PlaceModel? _selectedPlaceDetails;

  // Getters
  List<PlaceModel> get places => _places;
  bool get isLoadingPlaces => _isLoadingPlaces;
  bool get isFetchingMorePlaces => _isFetchingMorePlaces;
  String? get errorMessagePlaces => _errorMessagePlaces;
  bool get hasMorePlaces => _hasMorePlaces;
  bool get isEmptyPlaces => _places.isEmpty && !_isLoadingPlaces && _errorMessagePlaces == null;

  List<PlaceModel> get recommendedPlaces => _recommendedPlaces;
  bool get isLoadingRecommended => _isLoadingRecommended;
  String? get errorMessageRecommended => _errorMessageRecommended;
  bool get isEmptyRecommended => _recommendedPlaces.isEmpty && !_isLoadingRecommended && _errorMessageRecommended == null;

  List<PlaceModel> get summaryPlaces => _summaryPlaces;
  bool get isLoadingSummary => _isLoadingSummary;
  String? get errorMessageSummary => _errorMessageSummary;
  bool get isEmptySummary => _summaryPlaces.isEmpty && !_isLoadingSummary && _errorMessageSummary == null;

  PlaceModel? get selectedPlaceDetails => _selectedPlaceDetails;
  bool get isLoadingDetails => _isLoadingDetails;
  String? get errorMessageDetails => _errorMessageDetails;

  // 1. Fetch All Places (Paginated)
  Future<void> fetchPlaces({bool forceRefresh = false}) async {
    if (_hasFetchedPlaces && !forceRefresh) return;

    _isLoadingPlaces = true;
    _errorMessagePlaces = null;
    _currentPlacesPage = 1;
    _hasMorePlaces = true;
    notifyListeners();

    try {
      final items = await _placeService.fetchPlaces(page: _currentPlacesPage, limit: _limit);
      _places = items;
      _hasFetchedPlaces = true;
      if (items.length < _limit) {
        _hasMorePlaces = false;
      }
    } catch (e) {
      _errorMessagePlaces = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingPlaces = false;
      notifyListeners();
    }
  }

  Future<void> fetchMorePlaces() async {
    if (_isFetchingMorePlaces || !_hasMorePlaces || _isLoadingPlaces) return;

    _isFetchingMorePlaces = true;
    notifyListeners();

    try {
      _currentPlacesPage++;
      final items = await _placeService.fetchPlaces(page: _currentPlacesPage, limit: _limit);

      if (items.isEmpty) {
        _hasMorePlaces = false;
      } else {
        _places.addAll(items);
        if (items.length < _limit) {
          _hasMorePlaces = false;
        }
      }
    } catch (e) {
      _currentPlacesPage--;
    } finally {
      _isFetchingMorePlaces = false;
      notifyListeners();
    }
  }

  // 2. Fetch Recommended Places
  Future<void> fetchRecommendedPlaces({bool forceRefresh = false}) async {
    if (_hasFetchedRecommended && !forceRefresh) return;

    _isLoadingRecommended = true;
    _errorMessageRecommended = null;
    notifyListeners();

    try {
      final items = await _placeService.fetchRecommendedPlaces();
      _recommendedPlaces = items;
      _hasFetchedRecommended = true;
    } catch (e) {
      _errorMessageRecommended = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingRecommended = false;
      notifyListeners();
    }
  }

  // 3. Fetch Places Summary
  Future<void> fetchPlacesSummary({bool forceRefresh = false}) async {
    if (_hasFetchedSummary && !forceRefresh) return;

    _isLoadingSummary = true;
    _errorMessageSummary = null;
    notifyListeners();

    try {
      final items = await _placeService.fetchPlacesSummary();
      _summaryPlaces = items;
      _hasFetchedSummary = true;
    } catch (e) {
      _errorMessageSummary = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingSummary = false;
      notifyListeners();
    }
  }

  // 4. Fetch Place Details
  Future<void> fetchPlaceDetails(String id, {bool forceRefresh = false}) async {
    if (!forceRefresh && _placeDetailsCache.containsKey(id)) {
      _selectedPlaceDetails = _placeDetailsCache[id];
      _errorMessageDetails = null;
      notifyListeners();
      return;
    }

    _isLoadingDetails = true;
    _selectedPlaceDetails = null;
    _errorMessageDetails = null;
    notifyListeners();

    try {
      final detail = await _placeService.fetchPlaceDetails(id);
      _placeDetailsCache[id] = detail;
      _selectedPlaceDetails = detail;
    } catch (e) {
      _errorMessageDetails = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingDetails = false;
      notifyListeners();
    }
  }

  void clearCache() {
    _hasFetchedPlaces = false;
    _places = [];
    _errorMessagePlaces = null;
    _currentPlacesPage = 1;
    _hasMorePlaces = true;

    _hasFetchedRecommended = false;
    _recommendedPlaces = [];
    _errorMessageRecommended = null;

    _hasFetchedSummary = false;
    _summaryPlaces = [];
    _errorMessageSummary = null;

    _placeDetailsCache.clear();
    _selectedPlaceDetails = null;
    _errorMessageDetails = null;

    notifyListeners();
  }
}
