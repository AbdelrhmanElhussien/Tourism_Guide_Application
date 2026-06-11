import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tourist_app/core/utils/app_keys.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/mapTap/models/place_prediction_model.dart';

class GoogleMapsService {
  final Dio _dio = Dio();

  // Set to TRUE to use 100% Free Open-Source APIs (Nominatim & OSRM) during development.
  // Set to FALSE to use official Google Cloud Places & Directions APIs (Requires Billing Account).
  static const bool useFreeMockApis = true;

  // 1. Places Autocomplete API
  // Fetches suggestions as the user types in the search bar.
  Future<List<PlacePredictionModel>> getAutocompleteSuggestions(String input, String lang) async {
    if (input.isEmpty) return [];

    if (useFreeMockApis) {
      // Use OpenStreetMap Nominatim API (100% Free, no Billing or API key required)
      const String url = 'https://nominatim.openstreetmap.org/search';
      try {
        final response = await _dio.get(
          url,
          queryParameters: {
            'q': input,
            'format': 'json',
            'limit': 7,
            'accept-language': lang,
            // ✅ Restrict results to Egypt only
            'countrycodes': 'eg',
            // Egypt's bounding box: West, South, East, North
            'viewbox': '24.6981,21.7250,36.8995,31.6717',
            'bounded': 0, // 0 = prefer Egypt results but still show others if no local match
            'addressdetails': 1, // Return structured address details
          },
          options: Options(
            headers: {
              'User-Agent': 'tourist_app/1.0', // Required by Nominatim policy
            },
          ),
        );

        if (response.statusCode == 200) {
          final List data = response.data;
          return data.map((json) => PlacePredictionModel.fromJson(json)).toList();
        }
      } catch (e) {
        throw Exception('Free Search API Error: $e');
      }
      return [];
    }

    // Official Google Places Autocomplete API
    const String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    try {
      final response = await _dio.get(
        url,
        queryParameters: {
          'input': input,
          'key': AppKeys.googleMapsApiKey,
          'language': lang,
          // You can also restrict search region if needed (e.g., 'eg' for Egypt):
          // 'components': 'country:eg',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'OK') {
          final List predictions = data['predictions'];
          return predictions.map((json) => PlacePredictionModel.fromJson(json)).toList();
        } else {
          throw Exception('${data['status']}: ${data['error_message'] ?? "Unknown Error"}');
        }
      }
    } catch (e) {
      rethrow;
    }
    return [];
  }

  // 2. Google Place Details API
  // Gets precise LatLng coordinates for a specific place_id chosen by the user.
  Future<LatLng?> getPlaceLatLng(String placeId) async {
    if (useFreeMockApis) {
      // In Free Mode, coordinates are already embedded in the suggestion. 
      // This function is skipped in MapProvider.
      return null;
    }

    const String url = 'https://maps.googleapis.com/maps/api/place/details/json';
    try {
      final response = await _dio.get(
        url,
        queryParameters: {
          'place_id': placeId,
          'fields': 'geometry',
          'key': AppKeys.googleMapsApiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'OK') {
          final double lat = data['result']['geometry']['location']['lat'];
          final double lng = data['result']['geometry']['location']['lng'];
          return LatLng(lat, lng);
        } else {
          throw Exception('${data['status']}: ${data['error_message'] ?? "Unknown Error"}');
        }
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  // 3. Google Directions API / OSRM
  // Fetches polyline points, total distance, and duration between origin and destination.
  Future<Map<String, dynamic>?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    if (useFreeMockApis) {
      // Use OSRM (Open Source Routing Machine) API (100% Free, no Billing required)
      // Format: {lng},{lat};{lng},{lat}
      final String url = 'https://router.project-osrm.org/route/v1/driving/'
          '${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}';
      try {
        final response = await _dio.get(
          url,
          queryParameters: {
            'overview': 'full',
            'geometries': 'polyline', // Matches Google Maps encoded polyline format
          },
        );

        if (response.statusCode == 200) {
          final data = response.data;
          if (data['code'] == 'Ok') {
            final route = data['routes'][0];
            final double distanceInMeters = (route['distance'] as num).toDouble();
            final double durationInSeconds = (route['duration'] as num).toDouble();

            final String distanceText = '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
            
            // Format duration
            final int minutes = (durationInSeconds / 60).round();
            final String durationText = minutes > 60 
                ? '${(minutes / 60).toStringAsFixed(1)} hours' 
                : '$minutes mins';

            final String points = route['geometry'];

            return {
              'distance': distanceText,
              'duration': durationText,
              'points': points,
            };
          } else {
            throw Exception('OSRM Routing Error: ${data['code']}');
          }
        }
      } catch (e) {
        throw Exception('Free Routing API Error: $e');
      }
      return null;
    }

    // Official Google Directions API
    const String url = 'https://maps.googleapis.com/maps/api/directions/json';
    try {
      final response = await _dio.get(
        url,
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'key': AppKeys.googleMapsApiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'OK') {
          final route = data['routes'][0];
          final legs = route['legs'][0];

          // Fetch distance and duration texts
          final String distanceText = legs['distance']['text'];
          final String durationText = legs['duration']['text'];

          // Fetch overview polyline points (encoded string)
          final String points = route['overview_polyline']['points'];

          return {
            'distance': distanceText,
            'duration': durationText,
            'points': points,
          };
        } else {
          throw Exception('${data['status']}: ${data['error_message'] ?? "Unknown Error"}');
        }
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  // 4. Wikipedia Image API (Free, no key required)
  // Searches Wikipedia for a relevant thumbnail image based on the place name.
  Future<String> getPlaceImageUrl(String placeName, {String osmType = ''}) async {
    try {
      // Clean the place name for better search results
      final cleanedName = placeName.split(',').first.trim();

      final response = await _dio.get(
        'https://en.wikipedia.org/w/api.php',
        queryParameters: {
          'action': 'query',
          'titles': cleanedName,
          'prop': 'pageimages',
          'format': 'json',
          'pithumbsize': 800,
          'pilimit': 1,
          'origin': '*',
        },
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      if (response.statusCode == 200) {
        final pages = response.data['query']['pages'] as Map;
        final page = pages.values.first;
        final thumbnail = page['thumbnail'];
        if (thumbnail != null) {
          return thumbnail['source'] as String;
        }
      }
    } catch (_) {
      // Silently fall through to default image
    }

    // Fallback: OSM-type-based Unsplash images for Egypt
    return _getFallbackImage(osmType);
  }

  /// Returns a relevant fallback image from Unsplash based on the OSM place type.
  String _getFallbackImage(String osmType) {
    const Map<String, String> imageMap = {
      'museum':     'https://images.unsplash.com/photo-1572252009286-268acec5a0af?w=800&fit=crop',
      'historic':   'https://images.unsplash.com/photo-1569236096956-96bba2b0a95e?w=800&fit=crop',
      'mosque':     'https://images.unsplash.com/photo-1519817650390-64a993f9d5c8?w=800&fit=crop',
      'church':     'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&fit=crop',
      'park':       'https://images.unsplash.com/photo-1553913861-c0fddf2619ee?w=800&fit=crop',
      'restaurant': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&fit=crop',
      'hotel':      'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&fit=crop',
      'beach':      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&fit=crop',
      'castle':     'https://images.unsplash.com/photo-1544013919-455b9e898394?w=800&fit=crop',
      'ruins':      'https://images.unsplash.com/photo-1569236096956-96bba2b0a95e?w=800&fit=crop',
    };

    for (final entry in imageMap.entries) {
      if (osmType.toLowerCase().contains(entry.key)) {
        return entry.value;
      }
    }

    // Default Egypt landscape photo
    return 'https://images.unsplash.com/photo-1553913861-c0fddf2619ee?w=800&fit=crop';
  }
}
