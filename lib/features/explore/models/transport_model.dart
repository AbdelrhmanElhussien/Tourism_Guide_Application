class TransportModel {
  final String id;
  final String name;
  final String type;
  final String description;
  final String imageUrl;
  final String departureLocation;
  final String arrivalLocation;
  final String departureTime;
  final String arrivalTime;
  final double price;
  final int availableSeats;
  final int totalCapacity;
  final double rating;
  final int reviewCount;

  TransportModel({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.imageUrl,
    required this.departureLocation,
    required this.arrivalLocation,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.availableSeats,
    required this.totalCapacity,
    required this.rating,
    required this.reviewCount,
  });

  factory TransportModel.fromJson(Map<String, dynamic> json) {
    return TransportModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      departureLocation: json['departureLocation'] as String? ?? '',
      arrivalLocation: json['arrivalLocation'] as String? ?? '',
      departureTime: json['departureTime'] as String? ?? '',
      arrivalTime: json['arrivalTime'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      availableSeats: (json['availableSeats'] as num?)?.toInt() ?? 0,
      totalCapacity: (json['totalCapacity'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
    );
  }
}
