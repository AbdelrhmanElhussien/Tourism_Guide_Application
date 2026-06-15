class GuideModel {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String description;
  final String nationality;
  final String languages;
  final String specialization;
  final String imageUrl;
  final String bio;
  final double pricePerDay;
  final double rating;
  final int reviewCount;
  final bool isAvailable;

  GuideModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.description,
    required this.nationality,
    required this.languages,
    required this.specialization,
    required this.imageUrl,
    required this.bio,
    required this.pricePerDay,
    required this.rating,
    required this.reviewCount,
    required this.isAvailable,
  });

  factory GuideModel.fromJson(Map<String, dynamic> json) {
    return GuideModel(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      email: json['email'] as String? ?? '',
      description: json['description'] as String? ?? '',
      nationality: json['nationality'] as String? ?? '',
      languages: json['languages'] as String? ?? '',
      specialization: json['specialization'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      pricePerDay: (json['pricePerDay'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      isAvailable: json['isAvailable'] as bool? ?? false,
    );
  }

  List<String> get languagesList =>
      languages.split(',').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
}
