class PlacePredictionModel {
  final String placeId;
  final String mainText;
  final String secondaryText;
  final String description;
  final double? latitude;
  final double? longitude;
  final String osmType; // OSM type used for category-based image fallback

  PlacePredictionModel({
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
    required this.description,
    this.latitude,
    this.longitude,
    this.osmType = '',
  });

  factory PlacePredictionModel.fromJson(Map<String, dynamic> json) {
    // Nominatim format (contains lat/lon directly)
    if (json.containsKey('lat') && json.containsKey('lon')) {
      final String displayName = json['display_name'] ?? '';
      final List<String> parts = displayName.split(',');
      final String main = parts.isNotEmpty ? parts[0].trim() : displayName;
      final String secondary = parts.length > 1 ? parts.sublist(1).join(',').trim() : '';

      // Extract OSM class + type for better image matching (e.g. "tourism/museum")
      final String osmClass = json['class']?.toString() ?? '';
      final String osmTypeField = json['type']?.toString() ?? '';
      final String combinedType = '$osmClass $osmTypeField';

      return PlacePredictionModel(
        placeId: json['place_id']?.toString() ?? '',
        mainText: main,
        secondaryText: secondary,
        description: displayName,
        latitude: double.tryParse(json['lat']?.toString() ?? ''),
        longitude: double.tryParse(json['lon']?.toString() ?? ''),
        osmType: combinedType,
      );
    }

    // Google Places format
    final structuredFormatting = json['structured_formatting'] ?? {};
    return PlacePredictionModel(
      placeId: json['place_id'] ?? '',
      mainText: structuredFormatting['main_text'] ?? '',
      secondaryText: structuredFormatting['secondary_text'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
