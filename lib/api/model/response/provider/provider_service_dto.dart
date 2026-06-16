import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'provider_service_dto.g.dart';

@JsonSerializable()
class ProviderServiceDto {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "title")
  final String? title;
  @JsonKey(name: "category")
  final String? category;
  @JsonKey(name: "price")
  final double? price;
  @JsonKey(name: "bookingsCount")
  final int? bookingsCount;
  @JsonKey(name: "rating")
  final double? rating;
  @JsonKey(name: "imageUrl")
  final String? imageUrl;
  @JsonKey(name: "duration")
  final String? duration;
  @JsonKey(name: "location")
  final String? location;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "availability")
  final List<String>? availability;

  ProviderServiceDto({
    this.id,
    this.title,
    this.category,
    this.price,
    this.bookingsCount,
    this.rating,
    this.imageUrl,
    this.duration,
    this.location,
    this.description,
    this.availability,
  });

  factory ProviderServiceDto.fromJson(Map<String, dynamic> json) {
    return ProviderServiceDto(
      id: json['id'] as String?,
      title: json['title'] as String?,
      category: json['category'] as String?,
      price: json['price'] != null ? double.tryParse(json['price'].toString()) : null,
      bookingsCount: json['bookingsCount'] != null ? int.tryParse(json['bookingsCount'].toString()) : null,
      rating: json['rating'] != null ? double.tryParse(json['rating'].toString()) : null,
      imageUrl: json['imageUrl'] as String?,
      duration: json['duration'] as String?,
      location: json['location'] as String?,
      description: json['description'] as String?,
      availability: _availabilityFromJson(json['availability']),
    );
  }

  static List<String>? _availabilityFromJson(dynamic jsonVal) {
    if (jsonVal == null) return null;
    if (jsonVal is List) {
      return jsonVal.map((e) => e.toString()).toList();
    }
    if (jsonVal is String) {
      final String trimmed = jsonVal.trim();
      if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
        try {
          final decoded = jsonDecode(trimmed);
          if (decoded is List) {
            return decoded.map((e) => e.toString()).toList();
          }
        } catch (_) {}
      }
      return trimmed
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return null;
  }

  Map<String, dynamic> toJson() => _$ProviderServiceDtoToJson(this);
}
