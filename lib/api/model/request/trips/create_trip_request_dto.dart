import 'package:json_annotation/json_annotation.dart';

part 'create_trip_request_dto.g.dart';

@JsonSerializable()
class CreateTripRequestDto {
  @JsonKey(name: "title")
  final String? title;
  @JsonKey(name: "startDate")
  final String? startDate;
  @JsonKey(name: "endDate")
  final String? endDate;
  @JsonKey(name: "notes")
  final String? notes;

  CreateTripRequestDto({
    this.title,
    this.startDate,
    this.endDate,
    this.notes,
  });

  factory CreateTripRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateTripRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateTripRequestDtoToJson(this);
}
