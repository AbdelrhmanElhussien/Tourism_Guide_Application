import 'package:json_annotation/json_annotation.dart';

part 'create_activity_request_dto.g.dart';

@JsonSerializable()
class CreateActivityRequestDto {
  @JsonKey(name: "title")
  final String? title;
  @JsonKey(name: "time")
  final String? time;
  @JsonKey(name: "notes")
  final String? notes;
  @JsonKey(name: "imageUrl")
  final String? imageUrl;

  CreateActivityRequestDto({
    this.title,
    this.time,
    this.notes,
    this.imageUrl,
  });

  factory CreateActivityRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateActivityRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateActivityRequestDtoToJson(this);
}
