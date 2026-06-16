// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_trip_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTripRequestDto _$CreateTripRequestDtoFromJson(
  Map<String, dynamic> json,
) => CreateTripRequestDto(
  title: json['title'] as String?,
  startDate: json['startDate'] as String?,
  endDate: json['endDate'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$CreateTripRequestDtoToJson(
  CreateTripRequestDto instance,
) => <String, dynamic>{
  'title': instance.title,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'notes': instance.notes,
};
