// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceDto _$PlaceDtoFromJson(Map<String, dynamic> json) => PlaceDto(
  id: json['id'] as String?,
  name: json['name'] as String?,
  description: json['description'] as String?,
  category: json['category'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  imageUrl: json['imageUrl'] as String?,
  address: json['address'] as String?,
);

Map<String, dynamic> _$PlaceDtoToJson(PlaceDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'category': instance.category,
  'rating': instance.rating,
  'imageUrl': instance.imageUrl,
  'address': instance.address,
};
