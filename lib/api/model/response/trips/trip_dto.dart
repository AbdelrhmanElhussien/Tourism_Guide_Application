import 'package:json_annotation/json_annotation.dart';

part 'trip_dto.g.dart';

@JsonSerializable()
class TripDto {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "title")
  final String? title;
  @JsonKey(name: "startDate")
  final String? startDate;
  @JsonKey(name: "endDate")
  final String? endDate;
  @JsonKey(name: "notes")
  final String? notes;
  @JsonKey(name: "days")
  final List<TripDayDto>? days;

  TripDto({
    this.id,
    this.title,
    this.startDate,
    this.endDate,
    this.notes,
    this.days,
  });

  factory TripDto.fromJson(Map<String, dynamic> json) =>
      _$TripDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TripDtoToJson(this);
}

@JsonSerializable()
class TripDayDto {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "dayNumber")
  final int? dayNumber;
  @JsonKey(name: "date")
  final String? date;
  @JsonKey(name: "activities")
  final List<TripActivityDto>? activities;

  TripDayDto({
    this.id,
    this.dayNumber,
    this.date,
    this.activities,
  });

  factory TripDayDto.fromJson(Map<String, dynamic> json) =>
      _$TripDayDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TripDayDtoToJson(this);
}

@JsonSerializable()
class TripActivityDto {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "title")
  final String? title;
  @JsonKey(name: "time")
  final String? time;
  @JsonKey(name: "notes")
  final String? notes;
  @JsonKey(name: "imageUrl")
  final String? imageUrl;

  TripActivityDto({
    this.id,
    this.title,
    this.time,
    this.notes,
    this.imageUrl,
  });

  factory TripActivityDto.fromJson(Map<String, dynamic> json) =>
      _$TripActivityDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TripActivityDtoToJson(this);
}
