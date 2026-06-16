class HotelModel {
  final String id;
  final String name;
  final String location;
  final String city;
  final String country;
  final String description;
  final String imageUrl;
  final int starRating;
  final double pricePerNight;
  final double rating;
  final int reviewCount;
  final int availableRooms;
  final String amenities;
  final String contactNumber;
  final String email;

  HotelModel({
    required this.id,
    required this.name,
    required this.location,
    required this.city,
    required this.country,
    required this.description,
    required this.imageUrl,
    required this.starRating,
    required this.pricePerNight,
    required this.rating,
    required this.reviewCount,
    required this.availableRooms,
    required this.amenities,
    required this.contactNumber,
    required this.email,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      starRating: (json['starRating'] as num?)?.toInt() ?? 0,
      pricePerNight: (json['pricePerNight'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      availableRooms: (json['availableRooms'] as num?)?.toInt() ?? 0,
      amenities: json['amenities'] as String? ?? '',
      contactNumber: json['contactNumber'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }
}
