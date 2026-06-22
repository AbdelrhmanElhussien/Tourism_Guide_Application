// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_service_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProviderServiceDto _$ProviderServiceDtoFromJson(Map<String, dynamic> json) =>
    ProviderServiceDto(
      id: json['id'] as String?,
      title: json['title'] as String?,
      category: json['category'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      bookingsCount: (json['bookingsCount'] as num?)?.toInt(),
      rating: (json['rating'] as num?)?.toDouble(),
      imageUrl: json['imageUrl'] as String?,
      duration: json['duration'] as String?,
      location: json['location'] as String?,
      description: json['description'] as String?,
      availability: (json['availability'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      placeId: json['placeId'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      starRating: (json['starRating'] as num?)?.toInt(),
      availableRooms: (json['availableRooms'] as num?)?.toInt(),
      contactNumber: json['contactNumber'] as String?,
      email: json['email'] as String?,
      type: json['type'] as String?,
      departureLocation: json['departureLocation'] as String?,
      arrivalLocation: json['arrivalLocation'] as String?,
      departureTime: json['departureTime'] as String?,
      arrivalTime: json['arrivalTime'] as String?,
      totalCapacity: (json['totalCapacity'] as num?)?.toInt(),
      maxParticipants: (json['maxParticipants'] as num?)?.toInt(),
      includedServices: json['includedServices'] as String?,
      startDate: json['startDate'] as String?,
    );

Map<String, dynamic> _$ProviderServiceDtoToJson(ProviderServiceDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'price': instance.price,
      'bookingsCount': instance.bookingsCount,
      'rating': instance.rating,
      'imageUrl': instance.imageUrl,
      'duration': instance.duration,
      'location': instance.location,
      'description': instance.description,
      'availability': instance.availability,
      'placeId': instance.placeId,
      'city': instance.city,
      'country': instance.country,
      'starRating': instance.starRating,
      'availableRooms': instance.availableRooms,
      'contactNumber': instance.contactNumber,
      'email': instance.email,
      'type': instance.type,
      'departureLocation': instance.departureLocation,
      'arrivalLocation': instance.arrivalLocation,
      'departureTime': instance.departureTime,
      'arrivalTime': instance.arrivalTime,
      'totalCapacity': instance.totalCapacity,
      'maxParticipants': instance.maxParticipants,
      'includedServices': instance.includedServices,
      'startDate': instance.startDate,
    };
