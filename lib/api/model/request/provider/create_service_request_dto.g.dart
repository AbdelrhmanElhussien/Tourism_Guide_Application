// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_service_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateServiceRequestDto _$CreateServiceRequestDtoFromJson(
  Map<String, dynamic> json,
) => CreateServiceRequestDto(
  title: json['title'] as String?,
  description: json['description'] as String?,
  price: (json['price'] as num?)?.toDouble(),
  duration: json['duration'] as String?,
  location: json['location'] as String?,
  category: json['category'] as String?,
  availability: (json['availability'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$CreateServiceRequestDtoToJson(
  CreateServiceRequestDto instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'price': instance.price,
  'duration': instance.duration,
  'location': instance.location,
  'category': instance.category,
  'availability': instance.availability,
};
