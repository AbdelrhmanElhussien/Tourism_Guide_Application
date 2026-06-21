class ProviderService {
  final String id;
  final String title;
  final String category;
  final double price;
  final int bookingsCount;
  final double rating;
  final String imageUrl;
  final String duration;
  final String location;
  final String description;
  final List<String> availability;
  final String placeId;

  // Category-specific fields for editing details
  final String? city;
  final String? country;
  final int? starRating;
  final int? availableRooms;
  final String? contactNumber;
  final String? email;
  final String? type;
  final String? departureLocation;
  final String? arrivalLocation;
  final String? departureTime;
  final String? arrivalTime;
  final int? totalCapacity;
  final int? maxParticipants;
  final String? includedServices;
  final String? startDate;

  ProviderService({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.bookingsCount,
    required this.rating,
    required this.imageUrl,
    required this.duration,
    required this.location,
    required this.description,
    required this.availability,
    required this.placeId,
    this.city,
    this.country,
    this.starRating,
    this.availableRooms,
    this.contactNumber,
    this.email,
    this.type,
    this.departureLocation,
    this.arrivalLocation,
    this.departureTime,
    this.arrivalTime,
    this.totalCapacity,
    this.maxParticipants,
    this.includedServices,
    this.startDate,
  });
}
