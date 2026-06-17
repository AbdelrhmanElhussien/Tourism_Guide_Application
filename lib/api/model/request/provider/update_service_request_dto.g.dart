// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_service_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateServiceRequestDto _$UpdateServiceRequestDtoFromJson(
  Map<String, dynamic> json,
) => UpdateServiceRequestDto(
  placeId: json['placeId'] as String?,
  title: json['title'] as String?,
  category: json['category'] as String?,
  description: json['description'] as String?,
  price: (json['price'] as num?)?.toDouble(),
  currency: json['currency'] as String?,
  startDateTime: json['startDateTime'] as String?,
  endDateTime: json['endDateTime'] as String?,
  locationName: json['locationName'] as String?,
  imageUrl: json['imageUrl'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$UpdateServiceRequestDtoToJson(
  UpdateServiceRequestDto instance,
) => <String, dynamic>{
  'placeId': instance.placeId,
  'title': instance.title,
  'category': instance.category,
  'description': instance.description,
  'price': instance.price,
  'currency': instance.currency,
  'startDateTime': instance.startDateTime,
  'endDateTime': instance.endDateTime,
  'locationName': instance.locationName,
  'imageUrl': instance.imageUrl,
  'rating': instance.rating,
  'isActive': instance.isActive,
};
