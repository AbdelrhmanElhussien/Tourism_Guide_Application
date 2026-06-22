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
  @JsonKey(name: "placeId")
  final String? placeId;

  // Category-specific fields
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
    this.placeId,
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

  factory ProviderServiceDto.fromJson(Map<String, dynamic> json) {
    // Map list attributes if they are simple values
    List<String>? parsedAvailability;
    final rawAvailability = json['availability'] ?? json['amenities'] ?? json['arrivalLocation'] ?? json['category'] ?? json['languages'];
    if (rawAvailability != null) {
      if (rawAvailability is List) {
        parsedAvailability = rawAvailability.map((e) => e.toString()).toList();
      } else {
        parsedAvailability = [rawAvailability.toString()];
      }
    }

    return ProviderServiceDto(
      id: json['id'] as String?,
      title: json['title'] as String? ?? json['name'] as String? ?? json['fullName'] as String?,
      category: json['category'] as String?,
      price: json['price'] != null 
          ? double.tryParse(json['price'].toString()) 
          : (json['pricePerNight'] != null 
              ? double.tryParse(json['pricePerNight'].toString()) 
              : (json['pricePerDay'] != null 
                  ? double.tryParse(json['pricePerDay'].toString()) 
                  : null)),
      bookingsCount: json['bookingsCount'] != null ? int.tryParse(json['bookingsCount'].toString()) : null,
      rating: json['rating'] != null ? double.tryParse(json['rating'].toString()) : null,
      imageUrl: json['imageUrl'] as String?,
      duration: json['duration']?.toString() ?? json['type']?.toString(),
      location: json['location'] as String? ?? json['locationName'] as String? ?? json['departureLocation'] as String? ?? json['nationality'] as String?,
      description: json['description'] as String?,
      availability: parsedAvailability ?? _availabilityFromJson(json['availability']),
      placeId: json['placeId'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      starRating: json['starRating'] != null ? int.tryParse(json['starRating'].toString()) : null,
      availableRooms: json['availableRooms'] != null ? int.tryParse(json['availableRooms'].toString()) : null,
      contactNumber: json['contactNumber'] as String? ?? json['phoneNumber'] as String? ?? json['contactNumber'] as String?,
      email: json['email'] as String?,
      type: json['type'] as String?,
      departureLocation: json['departureLocation'] as String?,
      arrivalLocation: json['arrivalLocation'] as String?,
      departureTime: json['departureTime'] as String?,
      arrivalTime: json['arrivalTime'] as String?,
      totalCapacity: json['totalCapacity'] != null ? int.tryParse(json['totalCapacity'].toString()) : null,
      maxParticipants: json['maxParticipants'] != null ? int.tryParse(json['maxParticipants'].toString()) : null,
      includedServices: json['includedServices'] as String?,
      startDate: json['startDate'] as String?,
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
