// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_dashboard_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProviderDashboardDto _$ProviderDashboardDtoFromJson(
  Map<String, dynamic> json,
) => ProviderDashboardDto(
  totalEarnings: (json['totalEarnings'] as num?)?.toDouble(),
  earningsGrowth: json['earningsGrowth'] as String?,
  totalBookings: (json['totalBookings'] as num?)?.toInt(),
  bookingsGrowth: json['bookingsGrowth'] as String?,
  thisMonthBookings: (json['thisMonthBookings'] as num?)?.toInt(),
  thisMonthGrowth: json['thisMonthGrowth'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  ratingGrowth: json['ratingGrowth'] as String?,
  recentBookings: (json['recentBookings'] as List<dynamic>?)
      ?.map((e) => ProviderBookingDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ProviderDashboardDtoToJson(
  ProviderDashboardDto instance,
) => <String, dynamic>{
  'totalEarnings': instance.totalEarnings,
  'earningsGrowth': instance.earningsGrowth,
  'totalBookings': instance.totalBookings,
  'bookingsGrowth': instance.bookingsGrowth,
  'thisMonthBookings': instance.thisMonthBookings,
  'thisMonthGrowth': instance.thisMonthGrowth,
  'rating': instance.rating,
  'ratingGrowth': instance.ratingGrowth,
  'recentBookings': instance.recentBookings,
};
