import 'package:json_annotation/json_annotation.dart';

part 'provider_booking_dto.g.dart';

@JsonSerializable()
class ProviderBookingDto {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "title")
  final String? title;
  @JsonKey(name: "customerName")
  final String? customerName;
  @JsonKey(name: "date")
  final String? date;
  @JsonKey(name: "price")
  final double? price;
  @JsonKey(name: "status")
  final String? status;

  ProviderBookingDto({
    this.id,
    this.title,
    this.customerName,
    this.date,
    this.price,
    this.status,
  });

  factory ProviderBookingDto.fromJson(Map<String, dynamic> json) =>
      _$ProviderBookingDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProviderBookingDtoToJson(this);
}
