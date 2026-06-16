// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_activity_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateActivityRequestDto _$CreateActivityRequestDtoFromJson(
  Map<String, dynamic> json,
) => CreateActivityRequestDto(
  title: json['title'] as String?,
  time: json['time'] as String?,
  notes: json['notes'] as String?,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$CreateActivityRequestDtoToJson(
  CreateActivityRequestDto instance,
) => <String, dynamic>{
  'title': instance.title,
  'time': instance.time,
  'notes': instance.notes,
  'imageUrl': instance.imageUrl,
};
