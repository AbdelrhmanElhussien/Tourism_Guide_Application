import 'package:json_annotation/json_annotation.dart';

part 'provider_service_dto.g.dart';

@JsonSerializable()
class ProviderServiceDto {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "title")
  final String? title;
  @JsonKey(name: "category")
  final String? category;
  @JsonKey(name: "price")
  final double? price;
  @JsonKey(name: "bookingsCount")
  final int? bookingsCount;
  @JsonKey(name: "rating")
  final double? rating;
  @JsonKey(name: "imageUrl")
  final String? imageUrl;
  @JsonKey(name: "duration")
  final String? duration;
  @JsonKey(name: "location")
  final String? location;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "availability")
  final List<String>? availability;

  ProviderServiceDto({
    this.id,
    this.title,
    this.category,
    this.price,
    this.bookingsCount,
    this.rating,
    this.imageUrl,
    this.duration,
    this.location,
    this.description,
    this.availability,
  });

  factory ProviderServiceDto.fromJson(Map<String, dynamic> json) =>
      _$ProviderServiceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProviderServiceDtoToJson(this);
}
