// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripDto _$TripDtoFromJson(Map<String, dynamic> json) => TripDto(
  id: json['id'] as String?,
  title: json['title'] as String?,
  startDate: json['startDate'] as String?,
  endDate: json['endDate'] as String?,
  notes: json['notes'] as String?,
  days: (json['days'] as List<dynamic>?)
      ?.map((e) => TripDayDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TripDtoToJson(TripDto instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'notes': instance.notes,
  'days': instance.days,
};

TripDayDto _$TripDayDtoFromJson(Map<String, dynamic> json) => TripDayDto(
  id: json['id'] as String?,
  dayNumber: (json['dayNumber'] as num?)?.toInt(),
  date: json['date'] as String?,
  activities: (json['activities'] as List<dynamic>?)
      ?.map((e) => TripActivityDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TripDayDtoToJson(TripDayDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dayNumber': instance.dayNumber,
      'date': instance.date,
      'activities': instance.activities,
    };

TripActivityDto _$TripActivityDtoFromJson(Map<String, dynamic> json) =>
    TripActivityDto(
      id: json['id'] as String?,
      title: json['title'] as String?,
      time: json['time'] as String?,
      notes: json['notes'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$TripActivityDtoToJson(TripActivityDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'time': instance.time,
      'notes': instance.notes,
      'imageUrl': instance.imageUrl,
    };
