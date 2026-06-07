import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:tourist_app/core/utils/app_colors.dart';
import 'package:tourist_app/core/utils/toastUtils.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/mapTap/models/place_model.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/mapTap/models/place_prediction_model.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/mapTap/services/google_maps_service.dart';

class MapProvider extends ChangeNotifier {
  MapProvider() {
    _initializeLocation();
    loadTouristPlaces();
  }

  Future<void> _initializeLocation() async {
    await getUserLocation();
    getUserLocationUpdates();
  }

  final Location location = Location();
  final GoogleMapsService _googleMapsService = GoogleMapsService();
  late GoogleMapController mapController;
  final TextEditingController searchController = TextEditingController();

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(30.0444, 31.2357), // Default to Cairo
    zoom: 12,
  );

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  
  List<PlaceModel> allPlaces = [];
  List<PlaceModel> filteredPlaces = [];
  PlaceModel? selectedPlace;
  String selectedCategory = 'All';

  // Real-time Search Predictions from Google Places
  List<PlacePredictionModel> searchPredictions = [];

  // Routing Details
  String? routeDistance;
  String? routeDuration;
  LocationData? currentUserLocation;

  final List<String> categories = [
    'All',
    'Museum',
    'Historical',
    'Park',
    'Restaurant',
  ];

  // Nullable to avoid LateInitializationError if permission is denied before stream starts
  StreamSubscription<LocationData>? _locationStreem;

  void loadTouristPlaces() {
    // Mock Data - In production, this will come from an API
    allPlaces = [
      PlaceModel(
        id: '1',
        name: 'Egyptian Museum',
        description:
            'The Museum of Egyptian Antiquities, known commonly as the Egyptian Museum or Museum of Cairo, is home to an extensive collection of ancient Egyptian antiquities. It has 120,000 items, with a representative amount on display and the remainder in storerooms.',
        location: const LatLng(30.0478, 31.2336),
        category: 'Museum',
        rating: 4.8,
        image:
            'https://images.unsplash.com/photo-1572252009286-268acec5a0af?q=80&w=2070&auto=format&fit=crop',
        address: 'Tahrir Square, Cairo',
        transportOptions: [
          TransportOption(type: 'Metro', details: 'Sadat Station - 2 min walk'),
          TransportOption(type: 'Bus', details: 'Lines: 120, 150, 400'),
          TransportOption(type: 'Uber/Taxi', details: 'Accessible via Tahrir Sq.'),
        ],
      ),
      PlaceModel(
        id: '2',
        name: 'Cairo Citadel',
        description:
            'The Citadel of Cairo or Citadel of Saladin is a medieval Islamic-era fortification in Cairo, Egypt, built by Salah ad-Din and further developed by subsequent Egyptian rulers.',
        location: const LatLng(30.0299, 31.2611),
        category: 'Historical',
        rating: 4.7,
        image:
            'https://images.unsplash.com/photo-1544013919-455b9e898394?q=80&w=1974&auto=format&fit=crop',
        address: 'Salah Salem St, Cairo',
        transportOptions: [
          TransportOption(type: 'Bus', details: 'Line 20 - Drops at main gate'),
          TransportOption(type: 'Uber/Taxi', details: 'Drop off at Salah Salem gate'),
        ],
      ),
      PlaceModel(
        id: '3',
        name: 'Al-Azhar Park',
        description:
            'Al-Azhar Park is a public park located in Cairo, Egypt. Among several honors, this park is listed as one of the world\'s sixty great public spaces by the Project for Public Spaces.',
        location: const LatLng(30.0410, 31.2625),
        category: 'Park',
        rating: 4.6,
        image:
            'https://images.unsplash.com/photo-1553913861-c0fddf2619ee?q=80&w=2070&auto=format&fit=crop',
        address: 'Salah Salem St, Cairo',
        transportOptions: [
          TransportOption(type: 'Metro', details: 'Bab El-Shaaria (15 min walk)'),
          TransportOption(type: 'Taxi', details: 'Directly on Salah Salem Road'),
        ],
      ),
    ];
    filteredPlaces = allPlaces;
    _updateMarkers();
  }

  void filterByCategory(String category) {
    selectedCategory = category;
    _applyFilters();
  }

  // Google Places Autocomplete API Search
  Future<void> searchPlaces(String query) async {
    if (query.isEmpty) {
      searchPredictions = [];
      _applyFilters();
      notifyListeners();
      return;
    }

    try {
      // Call Places API to get real-time suggestion predictions
      searchPredictions = await _googleMapsService.getAutocompleteSuggestions(query, 'en');
      notifyListeners();
    } catch (e) {
      searchPredictions = [];
      notifyListeners();
      toastutils.flutterToast(
        msg: e.toString().replaceAll('Exception: ', ''),
        BackgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // Triggered when a user clicks on a search suggestion
  Future<void> selectPrediction(PlacePredictionModel prediction) async {
    try {
      // 1. Fetch precise LatLng using Place Details API or use pre-fetched coordinates (Free Mode)
      LatLng? destination;
      if (prediction.latitude != null && prediction.longitude != null) {
        destination = LatLng(prediction.latitude!, prediction.longitude!);
      } else {
        destination = await _googleMapsService.getPlaceLatLng(prediction.placeId);
      }
      if (destination == null) return;

      // 2. Clear predictions and update input field
      searchPredictions = [];
      searchController.text = prediction.mainText;

      // 3. Move camera to destination
      mapController.animateCamera(CameraUpdate.newLatLngZoom(destination, 15));

      // 4. Fetch a real image from Wikipedia for this place
      final String imageUrl = await _googleMapsService.getPlaceImageUrl(
        prediction.mainText,
        osmType: prediction.osmType,
      );

      // 5. Create and set the selected place
      final selectedPlaceFromSearch = PlaceModel(
        id: prediction.placeId,
        name: prediction.mainText,
        description: prediction.description,
        location: destination,
        category: prediction.osmType.isNotEmpty ? prediction.osmType.split(' ').last : 'Place',
        rating: 4.5,
        image: imageUrl,
        address: prediction.description,
      );
      selectedPlace = selectedPlaceFromSearch;

      // 5. Add temporary marker for the searched place
      markers.removeWhere((m) => m.markerId.value == 'searchResult');
      markers.add(
        Marker(
          markerId: const MarkerId('searchResult'),
          position: destination,
          infoWindow: InfoWindow(
            title: prediction.mainText,
            snippet: prediction.description,
          ),
        ),
      );

      // 6. Draw route if user's location is known
      if (currentUserLocation != null) {
        final userLatLng = LatLng(
          currentUserLocation!.latitude ?? 0,
          currentUserLocation!.longitude ?? 0,
        );
        await drawRoute(userLatLng, destination);
      }

      notifyListeners();
    } catch (e) {
      toastutils.flutterToast(
        msg: e.toString().replaceAll('Exception: ', ''),
        BackgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _applyFilters() {
    if (selectedCategory == 'All') {
      filteredPlaces = allPlaces;
    } else {
      filteredPlaces = allPlaces
          .where((place) => place.category == selectedCategory)
          .toList();
    }
    _updateMarkers();
    notifyListeners();
  }

  void _updateMarkers() {
    // Keep the user location marker if it exists
    Marker? userMarker;
    try {
      userMarker = markers.firstWhere((m) => m.markerId.value == 'myLocation');
    } catch (e) {
      // User marker not yet created
    }

    markers.clear();

    if (userMarker != null) {
      markers.add(userMarker);
    }

    for (var place in filteredPlaces) {
      markers.add(
        Marker(
          markerId: MarkerId(place.id),
          position: place.location,
          infoWindow: InfoWindow(
            title: place.name,
            snippet: '${place.category} • ⭐ ${place.rating}',
            onTap: () {
              selectPlace(place);
            },
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _getMarkerHue(place.category),
          ),
        ),
      );
    }
    notifyListeners();
  }

  double _getMarkerHue(String category) {
    switch (category) {
      case 'Museum':
        return BitmapDescriptor.hueAzure;
      case 'Historical':
        return BitmapDescriptor.hueOrange;
      case 'Park':
        return BitmapDescriptor.hueGreen;
      case 'Restaurant':
        return BitmapDescriptor.hueRed;
      default:
        return BitmapDescriptor.hueRed;
    }
  }

  void selectPlace(PlaceModel place) {
    selectedPlace = place;
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(place.location, 15),
    );

    // Draw route from user to place
    if (currentUserLocation != null) {
      final userLatLng = LatLng(
        currentUserLocation!.latitude ?? 0,
        currentUserLocation!.longitude ?? 0,
      );
      drawRoute(userLatLng, place.location);
    }

    notifyListeners();
  }

  void clearSelectedPlace() {
    selectedPlace = null;
    polylines.clear();
    routeDistance = null;
    routeDuration = null;
    markers.removeWhere((m) => m.markerId.value == 'searchResult');
    notifyListeners();
  }

  // Directions routing implementation
  Future<void> drawRoute(LatLng origin, LatLng destination) async {
    try {
      final routeDetails = await _googleMapsService.getDirections(
        origin: origin,
        destination: destination,
      );

      if (routeDetails != null) {
        routeDistance = routeDetails['distance'];
        routeDuration = routeDetails['duration'];
        final String encodedPoints = routeDetails['points'];

        // Decode polyline points
        final List<LatLng> decodedCoords = _decodePolyline(encodedPoints);

        polylines.clear();
        polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: decodedCoords,
            color: AppColors.primaryColor,
            width: 5,
          ),
        );

        // Auto-fit route in viewport
        _fitRouteBounds(decodedCoords);
      }
      notifyListeners();
    } catch (e) {
      toastutils.flutterToast(
        msg: e.toString().replaceAll('Exception: ', ''),
        BackgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  List<LatLng> _decodePolyline(String encodedPoints) {
    List<PointLatLng> decoded = PolylinePoints.decodePolyline(encodedPoints);
    return decoded.map((point) => LatLng(point.latitude, point.longitude)).toList();
  }

  void _fitRouteBounds(List<LatLng> points) {
    if (points.isEmpty) return;

    double? minLat, maxLat, minLng, maxLng;
    for (var point in points) {
      if (minLat == null || point.latitude < minLat) minLat = point.latitude;
      if (maxLat == null || point.latitude > maxLat) maxLat = point.latitude;
      if (minLng == null || point.longitude < minLng) minLng = point.longitude;
      if (maxLng == null || point.longitude > maxLng) maxLng = point.longitude;
    }

    if (minLat != null && maxLat != null && minLng != null && maxLng != null) {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );
      // Wait slightly for controller to be ready
      Future.delayed(const Duration(milliseconds: 100), () {
        mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
      });
    }
  }

  void updateUserMarker(LocationData locationData) {
    currentUserLocation = locationData;
    markers.removeWhere((m) => m.markerId.value == 'myLocation');
    markers.add(
      Marker(
        markerId: const MarkerId('myLocation'),
        position: LatLng(
          locationData.latitude ?? 0,
          locationData.longitude ?? 0,
        ),
        infoWindow: const InfoWindow(
          title: 'my location',
          snippet: 'my location',
        ),
      ),
    );
    notifyListeners();
  }

  void setCameraPosition(LocationData locationData) {
    cameraPosition = CameraPosition(
      target: LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0),
      zoom: 17,
    );
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    updateUserMarker(locationData);
  }

  void getUserLocationUpdates() {
    try {
      location.changeSettings(accuracy: LocationAccuracy.high, interval: 5000);
      _locationStreem = location.onLocationChanged.listen((
        LocationData currentLocation,
      ) {
        updateUserMarker(currentLocation);
      }, onError: (error) {
        print("Location stream error: $error");
      });
    } catch (e) {
      print("Error starting location updates: $e");
    }
  }

  Future<void> getUserLocation() async {
    try {
      bool isPermissionEnable = await _getLocationPermission();
      if (!isPermissionEnable) return;

      bool isGpsEnable = await _checkLocationService();
      if (!isGpsEnable) return;

      LocationData locationData = await location.getLocation();
      setCameraPosition(locationData);
      notifyListeners();
    } catch (e) {
      print("Error getting location: $e");
      toastutils.flutterToast(
        msg: "Could not fetch current location. Using default map center.",
        BackgroundColor: Colors.orange,
        textColor: Colors.white,
      );
    }
  }

  Future<bool> _getLocationPermission() async {
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
    }
    return (permissionStatus == PermissionStatus.granted ||
        permissionStatus == PermissionStatus.grantedLimited);
  }

  Future<bool> _checkLocationService() async {
    bool isServiceEnabled = await location.serviceEnabled();
    if (!isServiceEnabled) {
      isServiceEnabled = await location.requestService();
    }
    return isServiceEnabled;
  }

  @override
  void dispose() {
    _locationStreem?.cancel(); // Null-safe: only cancel if stream was actually started
    searchController.dispose();
    super.dispose();
  }
}
