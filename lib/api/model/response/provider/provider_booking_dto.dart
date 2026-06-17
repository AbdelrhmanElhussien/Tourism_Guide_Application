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
  @JsonKey(name: "guests")
  final int? guests;

  ProviderBookingDto({
    this.id,
    this.title,
    this.customerName,
    this.date,
    this.price,
    this.status,
    this.guests,
  });

  factory ProviderBookingDto.fromJson(Map<String, dynamic> json) {
    return ProviderBookingDto(
      id: json['id'] as String?,
      title: json['serviceTitle'] as String? ?? json['title'] as String?,
      customerName: json['customerName'] as String?,
      date: json['bookingDate'] as String? ?? json['date'] as String?,
      price: json['totalPrice'] != null 
          ? double.tryParse(json['totalPrice'].toString()) 
          : (json['price'] != null ? double.tryParse(json['price'].toString()) : null),
      status: json['status'] as String?,
      guests: json['guests'] as int?,
    );
  }

  Map<String, dynamic> toJson() => _$ProviderBookingDtoToJson(this);
}
