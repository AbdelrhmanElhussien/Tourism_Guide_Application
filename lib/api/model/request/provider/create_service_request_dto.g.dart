// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_service_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateServiceRequestDto _$CreateServiceRequestDtoFromJson(
  Map<String, dynamic> json,
) => CreateServiceRequestDto(
  placeId: json['placeId'] as String?,
  title: json['title'] as String?,
  category: json['category'] as String?,
  description: json['description'] as String?,
  price: (json['price'] as num?)?.toDouble(),
  currency: json['currency'] as String?,
  duration: json['duration'] as String?,
  locationName: json['locationName'] as String?,
  imageUrl: json['imageUrl'] as String?,
  availability: json['availability'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$CreateServiceRequestDtoToJson(
  CreateServiceRequestDto instance,
) => <String, dynamic>{
  'placeId': instance.placeId,
  'title': instance.title,
  'category': instance.category,
  'description': instance.description,
  'price': instance.price,
  'currency': instance.currency,
  'duration': instance.duration,
  'locationName': instance.locationName,
  'imageUrl': instance.imageUrl,
  'availability': instance.availability,
  'rating': instance.rating,
  'isActive': instance.isActive,
};
