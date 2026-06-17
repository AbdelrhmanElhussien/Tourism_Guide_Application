import 'package:json_annotation/json_annotation.dart';

part 'create_service_request_dto.g.dart';

@JsonSerializable()
class CreateServiceRequestDto {
  @JsonKey(name: "placeId")
  final String? placeId;
  @JsonKey(name: "title")
  final String? title;
  @JsonKey(name: "category")
  final String? category;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "price")
  final double? price;
  @JsonKey(name: "currency")
  final String? currency;
  @JsonKey(name: "duration")
  final String? duration;
  @JsonKey(name: "locationName")
  final String? locationName;
  @JsonKey(name: "imageUrl")
  final String? imageUrl;
  @JsonKey(name: "availability")
  final String? availability;
  @JsonKey(name: "rating")
  final double? rating;
  @JsonKey(name: "isActive")
  final bool? isActive;

  CreateServiceRequestDto({
    this.placeId,
    this.title,
    this.category,
    this.description,
    this.price,
    this.currency,
    this.duration,
    this.locationName,
    this.imageUrl,
    this.availability,
    this.rating,
    this.isActive = true,
  });

  factory CreateServiceRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateServiceRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateServiceRequestDtoToJson(this);
}
