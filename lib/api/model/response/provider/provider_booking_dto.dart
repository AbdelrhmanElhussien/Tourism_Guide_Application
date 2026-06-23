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
  @JsonKey(name: "imageUrl")
  final String? imageUrl;

  ProviderBookingDto({
    this.id,
    this.title,
    this.customerName,
    this.date,
    this.price,
    this.status,
    this.guests,
    this.imageUrl,
  });

  factory ProviderBookingDto.fromJson(Map<String, dynamic> json) {
    return ProviderBookingDto(
      id: json['id'] as String?,
      title: json['serviceTitle'] as String? ?? json['title'] as String?,
      customerName: json['customerName'] as String?,
      date: json['bookingDate'] as String? ?? 
            json['date'] as String? ?? 
            json['bookingDateTime'] as String? ?? 
            json['createdAt'] as String? ?? 
            json['startDate'] as String?,
      price: json['totalPrice'] != null 
          ? double.tryParse(json['totalPrice'].toString()) 
          : (json['price'] != null ? double.tryParse(json['price'].toString()) : null),
      status: json['status'] as String?,
      guests: (json['guests'] as num?)?.toInt() ?? 
              (json['numberOfPeople'] as num?)?.toInt() ?? 
              (json['numberOfGuests'] as num?)?.toInt() ?? 
              (json['numberOfParticipants'] as num?)?.toInt() ?? 
              (json['numberOfSeats'] as num?)?.toInt(),
      imageUrl: json['imageUrl'] as String? ?? 
                json['serviceImage'] as String? ?? 
                json['image'] as String? ?? 
                json['itemImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() => _$ProviderBookingDtoToJson(this);
}
