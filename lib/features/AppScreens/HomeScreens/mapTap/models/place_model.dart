import 'package:google_maps_flutter/google_maps_flutter.dart';

class TransportOption {
  final String type; // e.g., 'Metro', 'Bus', 'Taxi'
  final String details; // e.g., 'Sadat Station - 5 mins walk'

  TransportOption({required this.type, required this.details});
}

class PlaceModel {
  final String id;
  final String name;
  final String description;
  final LatLng location;
  final String category;
  final double rating;
  final String image;
  final String address;
  final List<TransportOption> transportOptions;

  PlaceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.category,
    required this.rating,
    required this.image,
    required this.address,
    this.transportOptions = const [],
  });
}
