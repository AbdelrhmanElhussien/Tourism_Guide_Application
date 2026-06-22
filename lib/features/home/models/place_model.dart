class PlaceModel {
  final String id;
  final String name;
  final String category;
  final String locationName;
  final String city;
  final String country;
  final String description;
  final String imageUrl;
  final String openingHours;
  final double rating;
  final int reviewCount;
  final double priceFrom;
  final double distanceKm;
  final double latitude;
  final double longitude;
  final bool isRecommended;
  final bool isPopular;
  final List<PlaceServiceOption> services;
  final List<NearbyPlaceOption> nearbyPlaces;
  final List<PlaceReview> reviews;

  PlaceModel({
    required this.id,
    required this.name,
    required this.category,
    required this.locationName,
    required this.city,
    required this.country,
    required this.description,
    required this.imageUrl,
    required this.openingHours,
    required this.rating,
    required this.reviewCount,
    required this.priceFrom,
    required this.distanceKm,
    required this.latitude,
    required this.longitude,
    required this.isRecommended,
    required this.isPopular,
    this.services = const [],
    this.nearbyPlaces = const [],
    this.reviews = const [],
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    double parseCoordinate(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    return PlaceModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      locationName: json['locationName'] as String? ?? '',
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      openingHours: json['openingHours'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      priceFrom: (json['priceFrom'] as num?)?.toDouble() ?? 0.0,
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      latitude: parseCoordinate(json['latitude']),
      longitude: parseCoordinate(json['longitude']),
      isRecommended: json['isRecommended'] as bool? ?? false,
      isPopular: json['isPopular'] as bool? ?? false,
      services: (json['services'] as List?)
              ?.map((item) => PlaceServiceOption.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      nearbyPlaces: (json['nearbyPlaces'] as List?)
              ?.map((item) => NearbyPlaceOption.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      reviews: (json['reviews'] as List?)
              ?.map((item) => PlaceReview.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class PlaceServiceOption {
  final String id;
  final String title;
  final String category;
  final double price;
  final String currency;
  final String duration;
  final String locationName;
  final String imageUrl;
  final double rating;
  final int bookingCount;

  PlaceServiceOption({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.currency,
    required this.duration,
    required this.locationName,
    required this.imageUrl,
    required this.rating,
    required this.bookingCount,
  });

  factory PlaceServiceOption.fromJson(Map<String, dynamic> json) {
    return PlaceServiceOption(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      locationName: json['locationName'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      bookingCount: (json['bookingCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class NearbyPlaceOption {
  final String id;
  final String name;
  final double rating;
  final String locationName;
  final String imageUrl;

  NearbyPlaceOption({
    required this.id,
    required this.name,
    required this.rating,
    required this.locationName,
    required this.imageUrl,
  });

  factory NearbyPlaceOption.fromJson(Map<String, dynamic> json) {
    return NearbyPlaceOption(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      locationName: json['locationName'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }
}

class PlaceReview {
  final String id;
  final int rating;
  final String comment;
  final String username;
  final String createdAt;

  PlaceReview({
    required this.id,
    required this.rating,
    required this.comment,
    required this.username,
    required this.createdAt,
  });

  factory PlaceReview.fromJson(Map<String, dynamic> json) {
    return PlaceReview(
      id: json['id'] as String? ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      comment: json['comment'] as String? ?? '',
      username: json['username'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }
}
