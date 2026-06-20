import 'package:json_annotation/json_annotation.dart';

part 'update_service_request_dto.g.dart';

@JsonSerializable()
class UpdateServiceRequestDto {
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
  @JsonKey(name: "startDateTime")
  final String? startDateTime;
  @JsonKey(name: "endDateTime")
  final String? endDateTime;
  @JsonKey(name: "locationName")
  final String? locationName;
  @JsonKey(name: "imageUrl")
  final String? imageUrl;
  @JsonKey(name: "rating")
  final double? rating;
  @JsonKey(name: "isActive")
  final bool? isActive;

  UpdateServiceRequestDto({
    this.placeId,
    this.title,
    this.category,
    this.description,
    this.price,
    this.currency,
    this.startDateTime,
    this.endDateTime,
    this.locationName,
    this.imageUrl,
    this.rating,
    this.isActive = true,
  });

  factory UpdateServiceRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateServiceRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateServiceRequestDtoToJson(this);
}
