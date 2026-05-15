import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapProvider extends ChangeNotifier {
  MapProvider() {
    getUserLocation();
    getUserLocationUpdates();
  }
  final Location location = Location();
  late GoogleMapController mapController;
  CameraPosition cameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  Set<Marker> markers = {};
  late final StreamSubscription<LocationData> _locationStreem;

  Future<bool> _getLocationPermission() async {
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
    }
    if (permissionStatus == PermissionStatus.granted ||
        permissionStatus == PermissionStatus.grantedLimited) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _checkLocationService() async {
    bool isServiceEnabled = await location.serviceEnabled();
    if (!isServiceEnabled) {
      isServiceEnabled = await location.requestService();
    }
    return isServiceEnabled;
  }

  void updateUserMarker(LocationData locationData) {
    markers.add(
      Marker(
        markerId: const MarkerId('myLocation'),
        position: LatLng(
          locationData.latitude ?? 0,
          locationData.longitude ?? 0,
        ),
        infoWindow:
            const InfoWindow(title: 'my location', snippet: 'my location'),
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

    if (!isPermissionEnable) {
      return;
    }

    bool isGpsEnable = await _checkLocationService();
    if (!isGpsEnable) {
      return;
    }

    LocationData locationData = await location.getLocation();
    setCameraPosition(locationData);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _locationStreem.cancel();
    notifyListeners();
  }
}
