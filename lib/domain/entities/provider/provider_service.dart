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
  });
}
