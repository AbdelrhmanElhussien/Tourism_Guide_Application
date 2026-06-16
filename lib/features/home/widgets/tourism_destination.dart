class TourismDestination {
  const TourismDestination({
    this.id,
    required this.title,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.category,
    this.assetImage,
    this.networkImage,
  });

  final String? id;
  final String title;
  final String location;
  final double rating;
  final int reviews;
  final String category;
  final String? assetImage;
  final String? networkImage;
}

const List<TourismDestination> tourismDestinations = [
  TourismDestination(
    title: 'Pyramids of Giza',
    location: 'Giza, Egypt',
    rating: 4.9,
    reviews: 12543,
    category: 'Historical',
    assetImage: 'assets/images/ImagePyramidsofGiza.png',
  ),
  TourismDestination(
    title: 'Cairo Citadel',
    location: 'Cairo, Egypt',
    rating: 4.7,
    reviews: 6543,
    category: 'Historical',
    networkImage: 'https://images.unsplash.com/photo-1572252009286-268acec5a0af?q=80&w=1200&auto=format&fit=crop',
  ),
  TourismDestination(
    title: 'Red Sea Resort',
    location: 'Hurghada, Egypt',
    rating: 4.6,
    reviews: 3210,
    category: 'Nature',
    networkImage: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1200&auto=format&fit=crop',
  ),
  TourismDestination(
    title: 'Luxor Temple',
    location: 'Luxor, Egypt',
    rating: 4.8,
    reviews: 8234,
    category: 'Cultural',
    networkImage: 'https://images.unsplash.com/photo-1601397922721-4326ae07bbc5?q=80&w=1200&auto=format&fit=crop',
  ),
];
