import 'package:json_annotation/json_annotation.dart';

part 'create_service_request_dto.g.dart';

@JsonSerializable()
class CreateServiceRequestDto {
  @JsonKey(name: "title")
  final String? title;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "price")
  final double? price;
  @JsonKey(name: "duration")
  final String? duration;
  @JsonKey(name: "location")
  final String? location;
  @JsonKey(name: "category")
  final String? category;
  @JsonKey(name: "availability")
  final List<String>? availability;

  CreateServiceRequestDto({
    this.title,
    this.description,
    this.price,
    this.duration,
    this.location,
    this.category,
    this.availability,
  });

  factory CreateServiceRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateServiceRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateServiceRequestDtoToJson(this);
}
