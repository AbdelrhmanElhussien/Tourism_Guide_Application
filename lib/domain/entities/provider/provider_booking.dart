class ProviderBooking {
  final String id;
  final String title;
  final String customerName;
  final String date;
  final double price;
  final String status;
  final int guests;
  final String imageUrl;

  ProviderBooking({
    required this.id,
    required this.title,
    required this.customerName,
    required this.date,
    required this.price,
    required this.status,
    required this.guests,
    required this.imageUrl,
  });
}
