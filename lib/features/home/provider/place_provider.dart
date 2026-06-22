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

  static final Map<String, Map<String, dynamic>> _fallbackPlacesData = {
    '8d42c009-1989-40a3-51d2-08decf833511': {
      'name': 'Abu Simbel Temples',
      'locationName': 'Abu Simbel, Aswan Governorate, Egypt',
      'city': 'Abu Simbel',
      'country': 'Egypt',
      'latitude': 22.3372,
      'longitude': 31.6258,
      'description': 'The Abu Simbel Temples are two massive rock-cut temples in Abu Simbel, Nubia, southern Egypt. They are situated on the western bank of Lake Nasser.',
      'openingHours': '06:00 AM - 05:00 PM',
      'priceFrom': 260.0,
      'distanceKm': 280.0,
    },
    '8239f999-b2b6-4daa-51d3-08decf833511': {
      'name': 'Philae Temple',
      'locationName': 'Philae Island, Aswan, Egypt',
      'city': 'Aswan',
      'country': 'Egypt',
      'latitude': 24.0264,
      'longitude': 32.8844,
      'description': 'Philae is an island in the reservoir of the Aswan Low Dam, downstream of the Aswan Dam and Lake Nasser, Egypt.',
      'openingHours': '07:00 AM - 04:00 PM',
      'priceFrom': 180.0,
      'distanceKm': 5.0,
    },
    '05244510-1845-424a-51d4-08decf833511': {
      'name': 'Nubian Museum',
      'locationName': 'Aswan, Egypt',
      'city': 'Aswan',
      'country': 'Egypt',
      'latitude': 24.0805,
      'longitude': 32.8943,
      'description': 'The Nubian Museum is an archaeological museum located in Aswan, Egypt. It was built to a design by architect Mahmoud El-Hakim.',
      'openingHours': '09:00 AM - 09:00 PM',
      'priceFrom': 140.0,
      'distanceKm': 2.0,
    },
    'cd81995f-9e62-43bb-51d5-08decf833511': {
      'name': 'Unfinished Obelisk',
      'locationName': 'Aswan, Egypt',
      'city': 'Aswan',
      'country': 'Egypt',
      'latitude': 24.0768,
      'longitude': 32.8954,
      'description': 'The unfinished obelisk is the largest known ancient obelisk and is located in the northern region of the stone quarries of ancient Egypt in Aswan.',
      'openingHours': '07:00 AM - 04:00 PM',
      'priceFrom': 80.0,
      'distanceKm': 2.5,
    },
    'a4d567ea-9524-4dbd-51d6-08decf833511': {
      'name': 'High Dam',
      'locationName': 'Aswan, Egypt',
      'city': 'Aswan',
      'country': 'Egypt',
      'latitude': 23.9695,
      'longitude': 32.8778,
      'description': 'The Aswan High Dam is the world\'s largest embankment dam, built across the Nile in Aswan, Egypt, between 1960 and 1970.',
      'openingHours': '09:00 AM - 05:00 PM',
      'priceFrom': 100.0,
      'distanceKm': 15.0,
    },
    'c663840f-5886-4818-51d9-08decf833511': {
      'name': 'Elephantine Island',
      'locationName': 'Aswan, Egypt',
      'city': 'Aswan',
      'country': 'Egypt',
      'latitude': 24.0883,
      'longitude': 32.8867,
      'description': 'Elephantine is an island on the Nile River in northern Nubia. It is part of the modern city of Aswan, in southern Egypt.',
      'openingHours': '08:00 AM - 05:00 PM',
      'priceFrom': 0.0,
      'distanceKm': 1.0,
    },
    'b45ef7ea-a524-4dbf-51d7-08decf833511': {
      'name': 'Botanical Garden',
      'locationName': 'El Nabatat Island, Aswan, Egypt',
      'city': 'Aswan',
      'country': 'Egypt',
      'latitude': 24.0935,
      'longitude': 32.8885,
      'description': 'Aswan Botanical Garden is located on El Nabatat Island in the Nile at Aswan, Egypt. It is a popular tourist attraction.',
      'openingHours': '08:00 AM - 06:00 PM',
      'priceFrom': 50.0,
      'distanceKm': 1.5,
    },
    'cd81995f-9e62-43bb-51d8-08decf833511': {
      'name': 'Monastery of St. Simeon',
      'locationName': 'West Bank, Aswan, Egypt',
      'city': 'Aswan',
      'country': 'Egypt',
      'latitude': 24.0851,
      'longitude': 32.8703,
      'description': 'The Monastery of St. Simeon is a 7th-century Christian monastery located on the west bank of the Nile opposite Aswan, Egypt.',
      'openingHours': '08:00 AM - 04:00 PM',
      'priceFrom': 60.0,
      'distanceKm': 3.0,
    },
    'a4d567ea-9524-4dbd-51d9-08decf833511': {
      'name': 'Tombs of the Nobles',
      'locationName': 'West Bank, Aswan, Egypt',
      'city': 'Aswan',
      'country': 'Egypt',
      'latitude': 24.1017,
      'longitude': 32.8862,
      'description': 'The Tombs of the Nobles in Aswan are a series of rock-cut tombs of ancient Egyptian governors and officials from the Old and Middle Kingdoms.',
      'openingHours': '07:00 AM - 05:00 PM',
      'priceFrom': 80.0,
      'distanceKm': 2.5,
    },
    'c663840f-5886-4818-51da-08decf833511': {
      'name': 'Temple of Kom Ombo',
      'locationName': 'Kom Ombo, Aswan Governorate, Egypt',
      'city': 'Kom Ombo',
      'country': 'Egypt',
      'latitude': 24.4712,
      'longitude': 32.9285,
      'description': 'The Temple of Kom Ombo is an unusual double temple in the town of Kom Ombo in Aswan Governorate, southern Egypt.',
      'openingHours': '09:00 AM - 05:00 PM',
      'priceFrom': 140.0,
      'distanceKm': 45.0,
    },
    'b45ef7ea-a524-4dbf-51db-08decf833511': {
      'name': 'Temple of Edfu',
      'locationName': 'Edfu, Aswan Governorate, Egypt',
      'city': 'Edfu',
      'country': 'Egypt',
      'latitude': 24.9782,
      'longitude': 32.8735,
      'description': 'The Temple of Edfu is an Egyptian temple located on the west bank of the Nile in Edfu, Upper Egypt.',
      'openingHours': '08:00 AM - 05:00 PM',
      'priceFrom': 180.0,
      'distanceKm': 105.0,
    },
    'cd81995f-9e62-43bb-51dc-08decf833511': {
      'name': 'Nubian Villages',
      'locationName': 'Gharb Soheil, Aswan, Egypt',
      'city': 'Aswan',
      'country': 'Egypt',
      'latitude': 24.0592,
      'longitude': 32.8687,
      'description': 'Gharb Soheil Nubian Village is located on the west bank of the Nile River, south of Aswan. It offers a glimpse into traditional Nubian life.',
      'openingHours': 'Open 24 Hours',
      'priceFrom': 0.0,
      'distanceKm': 7.0,
    },
  };

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
      final fallbackData = _fallbackPlacesData[id];
      if (fallbackData != null) {
        PlaceModel? existingPlace;
        try {
          existingPlace = _places.firstWhere((p) => p.id == id);
        } catch (_) {
          try {
            existingPlace = _recommendedPlaces.firstWhere((p) => p.id == id);
          } catch (_) {
            try {
              existingPlace = _summaryPlaces.firstWhere((p) => p.id == id);
            } catch (_) {}
          }
        }

        final enrichedPlace = PlaceModel(
          id: id,
          name: existingPlace?.name ?? fallbackData['name'] as String,
          category: existingPlace?.category ?? 'Historical',
          locationName: fallbackData['locationName'] as String,
          city: existingPlace?.city ?? fallbackData['city'] as String,
          country: existingPlace?.country ?? fallbackData['country'] as String,
          description: fallbackData['description'] as String,
          imageUrl: existingPlace?.imageUrl ?? '',
          openingHours: fallbackData['openingHours'] as String,
          rating: existingPlace?.rating ?? 4.5,
          reviewCount: existingPlace?.reviewCount ?? 12,
          priceFrom: fallbackData['priceFrom'] as double,
          distanceKm: fallbackData['distanceKm'] as double,
          latitude: fallbackData['latitude'] as double,
          longitude: fallbackData['longitude'] as double,
          isRecommended: existingPlace?.isRecommended ?? true,
          isPopular: existingPlace?.isPopular ?? true,
          services: const [],
          nearbyPlaces: const [],
          reviews: const [],
        );

        _placeDetailsCache[id] = enrichedPlace;
        _selectedPlaceDetails = enrichedPlace;
      } else {
        _errorMessageDetails = e.toString().replaceAll('Exception: ', '');
      }
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
