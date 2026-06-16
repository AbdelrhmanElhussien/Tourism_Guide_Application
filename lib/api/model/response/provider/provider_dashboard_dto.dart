import 'package:json_annotation/json_annotation.dart';
import 'provider_booking_dto.dart';

part 'provider_dashboard_dto.g.dart';

@JsonSerializable()
class ProviderDashboardDto {
  @JsonKey(name: "totalEarnings")
  final double? totalEarnings;
  @JsonKey(name: "earningsGrowth")
  final String? earningsGrowth;
  @JsonKey(name: "totalBookings")
  final int? totalBookings;
  @JsonKey(name: "bookingsGrowth")
  final String? bookingsGrowth;
  @JsonKey(name: "thisMonthBookings")
  final int? thisMonthBookings;
  @JsonKey(name: "thisMonthGrowth")
  final String? thisMonthGrowth;
  @JsonKey(name: "rating")
  final double? rating;
  @JsonKey(name: "ratingGrowth")
  final String? ratingGrowth;
  @JsonKey(name: "recentBookings")
  final List<ProviderBookingDto>? recentBookings;

  ProviderDashboardDto({
    this.totalEarnings,
    this.earningsGrowth,
    this.totalBookings,
    this.bookingsGrowth,
    this.thisMonthBookings,
    this.thisMonthGrowth,
    this.rating,
    this.ratingGrowth,
    this.recentBookings,
  });

  factory ProviderDashboardDto.fromJson(Map<String, dynamic> json) =>
      _$ProviderDashboardDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProviderDashboardDtoToJson(this);
}
