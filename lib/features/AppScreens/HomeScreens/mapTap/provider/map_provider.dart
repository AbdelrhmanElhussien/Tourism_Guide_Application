import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/mapTap/models/place_model.dart';

class MapProvider extends ChangeNotifier {
  MapProvider() {
    getUserLocation();
    getUserLocationUpdates();
    loadTouristPlaces();
  }

  final Location location = Location();
  late GoogleMapController mapController;
  final TextEditingController searchController = TextEditingController();

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(30.0444, 31.2357), // Default to Cairo
    zoom: 12,
  );

  Set<Marker> markers = {};
  List<PlaceModel> allPlaces = [];
  List<PlaceModel> filteredPlaces = [];
  PlaceModel? selectedPlace;
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Museum',
    'Historical',
    'Park',
    'Restaurant',
  ];

  late final StreamSubscription<LocationData> _locationStreem;

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

  void searchPlaces(String query) {
    if (query.isEmpty) {
      _applyFilters();
    } else {
      filteredPlaces = allPlaces.where((place) {
        final matchesQuery =
            place.name.toLowerCase().contains(query.toLowerCase());
        final matchesCategory =
            selectedCategory == 'All' || place.category == selectedCategory;
        return matchesQuery && matchesCategory;
      }).toList();
      _updateMarkers();
    }
    notifyListeners();
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
    notifyListeners();
  }

  void clearSelectedPlace() {
    selectedPlace = null;
    notifyListeners();
  }

  void updateUserMarker(LocationData locationData) {
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
    location.changeSettings(accuracy: LocationAccuracy.high, interval: 5000);
    _locationStreem = location.onLocationChanged.listen((
      LocationData currentLocation,
    ) {
      updateUserMarker(currentLocation);
    });
  }

  Future<void> getUserLocation() async {
    bool isPermissionEnable = await _getLocationPermission();
    if (!isPermissionEnable) return;

    bool isGpsEnable = await _checkLocationService();
    if (!isGpsEnable) return;

    LocationData locationData = await location.getLocation();
    setCameraPosition(locationData);
    notifyListeners();
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
    _locationStreem.cancel();
    searchController.dispose();
    super.dispose();
  }
}
