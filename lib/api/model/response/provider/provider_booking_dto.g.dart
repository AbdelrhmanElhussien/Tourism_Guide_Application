// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_booking_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProviderBookingDto _$ProviderBookingDtoFromJson(Map<String, dynamic> json) =>
    ProviderBookingDto(
      id: json['id'] as String?,
      title: json['title'] as String?,
      customerName: json['customerName'] as String?,
      date: json['date'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      status: json['status'] as String?,
      guests: (json['guests'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProviderBookingDtoToJson(ProviderBookingDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'customerName': instance.customerName,
      'date': instance.date,
      'price': instance.price,
      'status': instance.status,
      'guests': instance.guests,
    };
