import 'package:json_annotation/json_annotation.dart';

part 'place_dto.g.dart';

@JsonSerializable()
class PlaceDto {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "category")
  final String? category;
  @JsonKey(name: "rating")
  final double? rating;
  @JsonKey(name: "imageUrl")
  final String? imageUrl;
  @JsonKey(name: "address")
  final String? address;

  PlaceDto({
    this.id,
    this.name,
    this.description,
    this.category,
    this.rating,
    this.imageUrl,
    this.address,
  });

  factory PlaceDto.fromJson(Map<String, dynamic> json) =>
      _$PlaceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceDtoToJson(this);
}
