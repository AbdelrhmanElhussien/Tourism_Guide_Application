class ProgramModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String category;
  final String location;
  final String city;
  final String country;
  final double price;
  final int duration;
  final int maxParticipants;
  final int availableSpots;
  final String includedServices;
  final double rating;
  final int reviewCount;
  final String startDate;

  ProgramModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.location,
    required this.city,
    required this.country,
    required this.price,
    required this.duration,
    required this.maxParticipants,
    required this.availableSpots,
    required this.includedServices,
    required this.rating,
    required this.reviewCount,
    required this.startDate,
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      category: json['category'] as String? ?? '',
      location: json['location'] as String? ?? '',
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      maxParticipants: (json['maxParticipants'] as num?)?.toInt() ?? 0,
      availableSpots: (json['availableSpots'] as num?)?.toInt() ?? 0,
      includedServices: json['includedServices'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      startDate: json['startDate'] as String? ?? '',
    );
  }
}
